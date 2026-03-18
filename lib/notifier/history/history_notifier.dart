import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HistoryType { sales, purchase }

class HistoryNotifier extends Notifier<AsyncValue<List<Post>>> {
  final HistoryType type;

  HistoryNotifier(this.type);

  @override
  AsyncValue<List<Post>> build() {
    state = const AsyncLoading();
    _fetchHistory();
    return state;
  }

  Future<void> _fetchHistory() async {
    final userState = ref.watch(userProvider);
    final user = userState.value;
    
    if (user == null) {
      state = AsyncError(ServerFailure('사용자 정보가 없습니다.'), StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    final postRepo = ref.read(postRepositoryProvider);

    Result<List<Post>, Failure> result;
    if (type == HistoryType.sales) {
      result = await postRepo.getSalesHistory(user.uid);
    } else {
      result = await postRepo.getPurchaseHistory(user.uid);
    }

    switch (result) {
      case Success(:final value):
        state = AsyncData(value);
      case Error(:final failure):
        state = AsyncError(failure, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    await _fetchHistory();
  }

  Future<void> deletePosts(Set<String> postIds) async {
    final postRepo = ref.read(postRepositoryProvider);
    
    // 이 구현에서는 각 게시글을 개별적으로 삭제합니다.
    for (final id in postIds) {
       await postRepo.deletePost(id);
    }
    
    // 삭제 후 목록 새로고침
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
