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

String _$alarmNotifierHash() => r'90a9a8f9389aa5e3bbf06e6ed98844a49fdbe5d6';

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

@ProviderFor(unreadAlarmCount)
final unreadAlarmCountProvider = UnreadAlarmCountProvider._();

final class UnreadAlarmCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  UnreadAlarmCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadAlarmCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadAlarmCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return unreadAlarmCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unreadAlarmCountHash() => r'1e0c4b74d24e17ed0fca4ff1866ad80fed530bc9';
