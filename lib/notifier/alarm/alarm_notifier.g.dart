// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlarmNotifier)
final alarmProvider = AlarmNotifierProvider._();

final class AlarmNotifierProvider
    extends $AsyncNotifierProvider<AlarmNotifier, AlarmState> {
  AlarmNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alarmProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alarmNotifierHash();

  @$internal
  @override
  AlarmNotifier create() => AlarmNotifier();
}

String _$alarmNotifierHash() => r'cc1e7c6462d33fd7a02f53852393d983bb6c064e';

abstract class _$AlarmNotifier extends $AsyncNotifier<AlarmState> {
  FutureOr<AlarmState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AlarmState>, AlarmState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AlarmState>, AlarmState>,
              AsyncValue<AlarmState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
