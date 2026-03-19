import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/keyword.dart';
import 'package:baton/models/repositories/repository/search_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRepositoryImpl implements SearchRepository {
  final firestore = FirebaseFirestore.instance;

  @override
  Future<Result<List<Keyword>, Failure>> getHotKeywords() async {
    try {
      final snapshot = await firestore
          .collection('keywords')
          .orderBy('count', descending: true)
          .limit(10)
          .get();

      final keywords = snapshot.docs.map((doc) {
        return Keyword.fromJson(doc.data());
      }).toList();

      return Success(keywords);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('알 수 없는 에러가 발생했습니다.'));
    }
  }

  @override
  Future<Result<void, Failure>> updateSearchRecord(
    String uid,
    String keyword,
  ) async {
    try {
      final batch = firestore.batch();

      // 1. 키워드 검색량 증가 (set with merge를 통해 get 없이 1번의 쿼리로 처리)
      final keywordRef = firestore.collection('keywords').doc(keyword);
      batch.set(keywordRef, {
        'count': FieldValue.increment(1),
      }, SetOptions(merge: true));

      // 2. 유저의 최근 검색어 추가
      final userRef = firestore.collection('user').doc(uid);
      batch.update(userRef, {
        'recentlySearch': FieldValue.arrayUnion([keyword]),
      });

      await batch.commit();

      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('알 수 없는 에러가 발생했습니다.'));
    }
  }
}
