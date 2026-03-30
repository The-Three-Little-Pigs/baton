import 'package:baton/models/repositories/repository/alarm_repository.dart';
import 'package:baton/models/repositories/repository_impl/alarm_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alarm_provider.g.dart';

@Riverpod(keepAlive: true)
AlarmRepository alarmRepository(Ref ref) {
  return AlarmRepositoryImpl();
}
