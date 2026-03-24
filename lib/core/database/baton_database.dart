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

/// 찜 목록 테이블 정의 (Post ID 기준)
class Favorites extends Table {
  TextColumn get postId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {postId};
}

/// 차단 목록 테이블 정의 (User UID 기준)
class Blocks extends Table {
  TextColumn get blockedUid => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {blockedUid};
}

@DriftDatabase(tables: [SearchHistories, Favorites, Blocks])
class BatonDatabase extends _$BatonDatabase {
  BatonDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // 버전 1에서 2로 올라갈 때 추가된 테이블 생성
            await m.createTable(favorites);
            await m.createTable(blocks);
          }
        },
      );

  // --- Search History ---

  /// 특정 검색어 추가 (중복 시 기존 삭제 후 최신으로 추가, 최대 10개 유지)
  Future<void> addSearchHistory(String query) {
    return transaction(() async {
      await (delete(searchHistories)..where((t) => t.query.equals(query))).go();
      await into(searchHistories).insert(
        SearchHistoriesCompanion.insert(query: query),
      );
      final allHistories = await getAllSearchHistories();
      if (allHistories.length > 10) {
        for (var i = 10; i < allHistories.length; i++) {
          await deleteSearchHistory(allHistories[i].id);
        }
      }
    });
  }

  Future<List<SearchHistory>> getAllSearchHistories() {
    return (select(searchHistories)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<int> deleteSearchHistory(int id) {
    return (delete(searchHistories)..where((t) => t.id.equals(id))).go();
  }

  Future<int> clearAllSearchHistories() {
    return delete(searchHistories).go();
  }

  // --- Favorites ---

  /// 찜 추가/해제 (Toggle)
  Future<void> toggleFavorite(String postId) {
    return transaction(() async {
      final exists = await isFavorite(postId);
      if (exists) {
        await (delete(favorites)..where((t) => t.postId.equals(postId))).go();
      } else {
        await into(favorites).insert(
          FavoritesCompanion.insert(postId: postId),
        );
      }
    });
  }

  /// 찜 목록 조회용 스트림
  Stream<List<Favorite>> watchAllFavorites() {
    return select(favorites).watch();
  }

  /// 찜 여부 확인 (동기적 체크용)
  Future<bool> isFavorite(String postId) async {
    final query = select(favorites)..where((t) => t.postId.equals(postId));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  /// 찜 삭제 (명시적)
  Future<void> removeFavorite(String postId) {
    return (delete(favorites)..where((t) => t.postId.equals(postId))).go();
  }

  /// 모든 찜 목록 조회
  Future<List<Favorite>> getAllFavorites() {
    return select(favorites).get();
  }

  // --- Blocks ---

  /// 유저 차단/해제 (Toggle)
  Future<void> toggleBlock(String blockedUid) {
    return transaction(() async {
      final exists = await isBlocked(blockedUid);
      if (exists) {
        await removeBlock(blockedUid);
      } else {
        await into(blocks).insert(
          BlocksCompanion.insert(blockedUid: blockedUid),
        );
      }
    });
  }

  /// 차단 목록 조회용 스트림
  Stream<List<Block>> watchAllBlocks() {
    return select(blocks).watch();
  }

  /// 차단 여부 확인
  Future<bool> isBlocked(String blockedUid) async {
    final query = select(blocks)..where((t) => t.blockedUid.equals(blockedUid));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  /// 차단 삭제 (명시적)
  Future<void> removeBlock(String blockedUid) {
    return (delete(blocks)..where((t) => t.blockedUid.equals(blockedUid))).go();
  }

  /// 모든 차단 유저 목록 조회
  Future<List<Block>> getAllBlocks() {
    return select(blocks).get();
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
