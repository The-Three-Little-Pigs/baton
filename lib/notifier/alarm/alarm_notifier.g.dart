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
    extends $StreamNotifierProvider<AlarmNotifier, List<Alarm>> {
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

String _$alarmNotifierHash() => r'394dbf85d8e0e9e4f45f6ff19a09964c2be91ae0';

abstract class _$AlarmNotifier extends $StreamNotifier<List<Alarm>> {
  Stream<List<Alarm>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Alarm>>, List<Alarm>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Alarm>>, List<Alarm>>,
              AsyncValue<List<Alarm>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// 읽지 않은 알림 개수를 계산하는 Provider

@ProviderFor(unreadAlarmCount)
final unreadAlarmCountProvider = UnreadAlarmCountProvider._();

/// 읽지 않은 알림 개수를 계산하는 Provider

final class UnreadAlarmCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// 읽지 않은 알림 개수를 계산하는 Provider
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

String _$unreadAlarmCountHash() => r'aaa0d83cf104a2235f9047f98c4008b0bf4f3451';
