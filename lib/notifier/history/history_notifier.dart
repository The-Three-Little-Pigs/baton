import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


enum HistoryType { sales, purchase }

class HistoryNotifier extends Notifier<AsyncValue<List<Post>>> {
  final HistoryType type;

  HistoryNotifier(this.type);

  String? _lastUid;

  @override
  AsyncValue<List<Post>> build() {
    // userProvider를 감시하여 사용자 상태 변경 시 자동으로 build 재실행
    final userAsync = ref.watch(userProvider);
    
    return userAsync.when(
      data: (user) {
        if (user == null) {
          _lastUid = null;
          return const AsyncData([]);
        }
        
        // 사용자가 바뀌었거나 아직 데이터를 가져오기 전인 경우
        if (_lastUid != user.uid) {
          _lastUid = user.uid;
          Future.microtask(() => _fetchHistory(user.uid));
          return const AsyncLoading();
        }
        
        // 사용자가 그대로인 경우 (예: 다른 UI 상태 변경으로 인한 재빌드)
        // 이미 데이터가 있다면 기존 state를 유지하고, 없으면 로딩
        try {
          return state;
        } catch (_) {
          // 혹시 모를 첫 빌드 예외 상황 대응
          Future.microtask(() => _fetchHistory(user.uid));
          return const AsyncLoading();
        }
      },
      loading: () => const AsyncLoading(),
      error: (error, stack) => AsyncError(error, stack),
    );
  }

  Future<void> _fetchHistory(String uid) async {
    final postRepo = ref.read(postRepositoryProvider);

    Result<List<Post>, Failure> result;
    if (type == HistoryType.sales) {
      result = await postRepo.getSalesHistory(uid);
    } else {
      result = await postRepo.getPurchaseHistory(uid);
    }



    switch (result) {
      case Success(:final value):
        state = AsyncData(value);
      case Error(:final failure):
        state = AsyncError(failure, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    final uid = ref.read(userProvider).value?.uid;
    if (uid != null) {
      await _fetchHistory(uid);
    }
  }

  Future<void> deletePosts(Set<String> postIds) async {
    final postRepo = ref.read(postRepositoryProvider);
    final currentPosts = state.value ?? [];

    // 1. 삭제 대상 중 '거래중' 제외 필터링 (방어 로직)
    final idsToHide = postIds.where((id) {
      try {
        final post = currentPosts.firstWhere((p) => p.postId == id);
        return post.status != ProductStatus.reserved;
      } catch (_) {
        return false;
      }
    }).toSet();

    if (idsToHide.isEmpty) return;

    // 2. 낙관적 UI 업데이트: 서버 응답 전 로컬 상태에서 즉시 제거
    state = AsyncData(
      currentPosts.where((p) => !idsToHide.contains(p.postId)).toList(),
    );

    // 3. 서버 업데이트 수행
    for (final id in idsToHide) {
      try {
        if (type == HistoryType.sales) {
          await postRepo.hidePostFromSalesHistory(id);
        } else {
          await postRepo.hidePostFromPurchaseHistory(id);
        }
      } catch (e) {
        debugPrint('Failed to hide post $id: $e');
      }
    }

    // 4. 모든 작업 완료 후 서버 데이터와 최종 동기화
    await refresh();
  }
}

// 판매 내역 제공자
final salesHistoryProvider = NotifierProvider<HistoryNotifier, AsyncValue<List<Post>>>(() {
  return HistoryNotifier(HistoryType.sales);
});

// 구매 내역 제공자
final purchaseHistoryProvider = NotifierProvider<HistoryNotifier, AsyncValue<List<Post>>>(() {
  return HistoryNotifier(HistoryType.purchase);
});
