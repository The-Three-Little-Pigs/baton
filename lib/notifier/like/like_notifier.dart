import 'package:baton/core/di/db/db_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/category.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/models/repositories/repository/like_repository.dart';
import 'package:baton/models/repositories/repository_impl/like_repository_impl.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'like_notifier.g.dart';

@riverpod
LikeRepository likeRepository(Ref ref) {
  final database = ref.watch(batonDatabaseProvider);
  return LikeRepositoryImpl(database: database);
}

@Riverpod(keepAlive: true)
class LikeNotifier extends _$LikeNotifier {
  @override
  FutureOr<List<Post>> build() async {
    final user = ref.watch(userProvider);
    final currentUserId = user.value?.uid ?? "";
    if (currentUserId.isEmpty) return [];

    // 1. 로컬 DB에서 먼저 데이터 가져오기 (비동기로 시작하지만 즉시 상태 반영 시도)
    _loadLocalFavorites();

    // 2. 서버 데이터 가져오기 (전체 리스트 갱신)
    return _fetchLikedPosts(currentUserId);
  }

  /// 로컬 DB의 찜 목록을 즉시 로딩하여 state에 반영 (낙관적 로딩)
  Future<void> _loadLocalFavorites() async {
    final database = ref.watch(batonDatabaseProvider);
    final localFavorites = await database.getAllFavorites();
    
    // 현재 state가 아직 로딩 중이라면 로컬 데이터로 먼저 채워줌
    if (state.isLoading || state.hasError) {
      // 주의: Post 객체 전체 정보가 로컬에는 없으므로, ID만 있는 가짜 객체나 
      // 기존에 알고 있던 최소 정보로 구성해야 함. 
      // 여기서는 일단 ID 기반으로 동작을 확인하거나, 
      // 추후 Post 엔티티도 로컬 캐싱하는 방향으로 확장 가능.
      // 일단은 데이터 정합성을 위해 ID만 일치시켜도 하트 아이콘 등은 반응함.
      final placeholderPosts = localFavorites.map((f) => Post(
        postId: f.postId,
        title: '불러오는 중...', 
        content: '',
        authorId: '',
        category: Category.etc, // 가구 대신 기타로 수정
        salePrice: 0,
        imageUrls: [],
        createdAt: f.createdAt,
        likeCount: 0,
        chatCount: 0,
        status: ProductStatus.available,
      )).toList();
      
      state = AsyncData(placeholderPosts);
    }
  }

  Future<List<Post>> _fetchLikedPosts(String currentUserId) async {
    final repository = ref.read(likeRepositoryProvider);
    final result = await repository.getLikedPosts(currentUserId);

    switch (result) {
      case Success(:final value):
        return value; // 성공 시 리스트 반환
      case Error(:final failure):
        throw Exception(failure.message); // 에러 시 throw
    }
  }

  Future<void> toggleLike(Post post) async {
    final user = ref.read(userProvider).value;
    if (user == null || user.uid.isEmpty) {
      // 로그인이 필요함을 알리는 에러 처리나 알림 필요 (여기서는 중단)
      return;
    }
    
    final currentUserId = user.uid;
    final previousState = state; // 실패 시 원복을 위한 보험 데이터

    // (1) UI 낙관적 렌더링 - 서버를 기다리지 않고 화면용 데이터부터 먼저 조작!
    if (state.value != null) {
      final currentList = List<Post>.from(state.value!);

      // 이미 찜한 리스트에 있는지 확인
      final isLikedIndex = currentList.indexWhere(
        (p) => p.postId == post.postId,
      );
      if (isLikedIndex >= 0) {
        currentList.removeAt(isLikedIndex); // 있었으면 목록에서 삭제
      } else {
        // 없었으면 맨 앞에 삽입. 그리고 (화면만이라도) 카운트 1 올린 가짜 복사본을 보여줌
        final updatedPost = post.copyWith(likeCount: post.likeCount + 1);
        currentList.insert(0, updatedPost);
      }

      // 상태 갱신 방송. "앱 안의 모든 하트 위젯들아! 방금 데이터 이거야! 다 즉시 바뀌어라!"
      state = AsyncData(currentList);
    }
    // (2) 이제 백그라운드에서 진짜 통신 진행
    final repository = ref.read(likeRepositoryProvider);
    final result = await repository.toggleLike(post.postId, currentUserId);
    // (3) 실패 시에만 유저 화면을 이전 데이터로 되돌림(Rollback)
    if (result is Error) {
      state = previousState; // 실패 시 원복
    }
  }
}
