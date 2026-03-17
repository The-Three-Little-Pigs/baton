import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/hot_keyword.dart';
import 'package:baton/models/repositories/repository/search_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRepositoryImpl implements SearchRepository {
  final firestore = FirebaseFirestore.instance;

  @override
  Future<Result<List<HotKeyword>, Failure>> getHotKeywords() async {
    try {
      final snapshot = await firestore
          .collection('hot_keywords')
          .orderBy('count', descending: true)
          .limit(10)
          .get();

      final hotKeywords = snapshot.docs.map((doc) {
        return HotKeyword.fromJson(doc.data());
      }).toList();

      return Success(hotKeywords);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('알 수 없는 에러가 발생했습니다.'));
    }
  }

  @override
  Future<Result<void, Failure>> updateKeyword(String keyword) async {
    try {
      final snapshot = await firestore
          .collection('keywords')
          .doc(keyword)
          .get();

      if (snapshot.exists) {
        await firestore.collection('keywords').doc(keyword).update({
          'count': FieldValue.increment(1),
        });
      } else {
        await firestore.collection('keywords').doc(keyword).set({'count': 1});
      }

      return Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('알 수 없는 에러가 발생했습니다.'));
    }
  }
}
