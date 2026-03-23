import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

part 'baton_database.g.dart';

/// 최근 검색어 테이블 정의
class SearchHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text().withLength(min: 1, max: 50)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [SearchHistories])
class BatonDatabase extends _$BatonDatabase {
  BatonDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// 특정 검색어 추가 (중복 시 기존 삭제 후 최신으로 추가, 최대 10개 유지)
  Future<void> addSearchHistory(String query) {
    return transaction(() async {
      // 1. 기존 중복 검색어 삭제 (최신화를 위해)
      await (delete(searchHistories)..where((t) => t.query.equals(query))).go();

      // 2. 신규 검색어 추가
      await into(searchHistories).insert(
        SearchHistoriesCompanion.insert(query: query),
      );

      // 3. 10개가 넘어가면 오래된 기록 삭제
      final allHistories = await getAllSearchHistories();
      if (allHistories.length > 10) {
        // 10번째 이후의 데이터 삭제
        for (var i = 10; i < allHistories.length; i++) {
          await deleteSearchHistory(allHistories[i].id);
        }
      }
    });
  }

  /// 모든 검색 기록 최신순 조회
  Future<List<SearchHistory>> getAllSearchHistories() {
    return (select(searchHistories)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .get();
  }

  /// 특정 검색어 삭제
  Future<int> deleteSearchHistory(int id) {
    return (delete(searchHistories)..where((t) => t.id.equals(id))).go();
  }

  /// 모든 검색어 삭제
  Future<int> clearAllSearchHistories() {
    return delete(searchHistories).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'baton.sqlite'));

    // 임시 디렉토리를 sqlite3가 사용할 수 있도록 설정
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
