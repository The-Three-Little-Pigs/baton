import 'package:baton/core/database/baton_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_provider.g.dart';

@riverpod
BatonDatabase batonDatabase(Ref ref) {
  final db = BatonDatabase();
  
  // 앱 종료 시 DB 리소스 해제
  ref.onDispose(() {
    db.close();
  });
  
  return db;
}
