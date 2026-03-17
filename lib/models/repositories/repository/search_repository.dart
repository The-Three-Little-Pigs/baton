import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/hot_keyword.dart';

abstract interface class SearchRepository {
  Future<Result<List<HotKeyword>, Failure>> getHotKeywords();
  Future<Result<void, Failure>> updateKeyword(String keyword);
}
