import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/category.dart';
import 'package:baton/models/repositories/repository/post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepositoryImpl implements PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<void, Failure>> createPost(Post post) async {
    try {
      final docRef = _firestore.collection('posts').doc();

      await docRef.set(
        post.copyWith(postId: docRef.id).toJson(),
        SetOptions(merge: true),
      );

      return Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> deletePost(String postId) async {
    try {
      final docRef = _firestore.collection('posts').doc(postId);
      await docRef.delete();

      return Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<List<Post>, Failure>> getPosts(
    Set<Category>? categories,
    DateTime? lastTime,
    String? lastPostId,
  ) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection('posts')
          .orderBy('created_at', descending: true);

      if (categories != null && categories.isNotEmpty) {
        final categoryNames = categories.map((c) => c.label).toList();
        query = query.where('category', whereIn: categoryNames);
      }

      if (lastTime != null) {
        // startAfter를 사용하여 이전 페이지의 마지막 데이터 이후부터 가져옴
        query = query.startAfter([Timestamp.fromDate(lastTime)]);
      }

      final snapshot = await query.limit(20).get();

      final posts = snapshot.docs
          .map((doc) => Post.fromJson(doc.data()))
          .toList();

      return Success(posts);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('데이터를 불러오는 중 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Result<List<Post>, Failure>> getSalesHistory(String userId) async {
    try {
      final query = _firestore
          .collection('posts')
          .where('author_id', isEqualTo: userId);

      final snapshot = await query.get();
      final posts = snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
      
      // 로컬에서 최신순 정렬 (Firestore 복합 인덱스 에러 방지)
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return Success(posts);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('판매 내역을 불러오는 중 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Result<List<Post>, Failure>> getPurchaseHistory(String userId) async {
    try {
      // TODO: 추후 구매 트랜잭션 컬렉션이 구체화되면 쿼리를 변경해야 합니다.
      // 일단은 에러가 나지 않도록 임시로 빈 리스트를 반환합니다.
      return const Success([]);
    } catch (e) {
      return Error(ServerFailure('구매 내역을 불러오는 중 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> updatePost(Post post) async {
    try {
      final docRef = _firestore.collection('posts').doc(post.postId);
      await docRef.update(post.toJson());

      return Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<Post, Failure>> getPostById(String postId) async {
    try {
      final docRef = _firestore.collection('posts').doc(postId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Error(ServerFailure('Post not found'));
      }

      final post = Post.fromJson(doc.data()!);
      return Success(post);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> incrementViewCount(String postId) async {
    try {
      final docRef = _firestore.collection('posts').doc(postId);
      await docRef.update({
        'view_count': FieldValue.increment(1),
      });
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('조회수 업데이트 중 오류가 발생했습니다: $e'));
    }
  }
}
