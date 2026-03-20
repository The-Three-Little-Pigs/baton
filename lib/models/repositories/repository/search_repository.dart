import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/keyword.dart';

abstract class SearchRepository {
  Future<Result<List<Keyword>, Failure>> getHotKeywords();
  Future<Result<void, Failure>> updateSearchRecord(String uid, String keyword);
}
