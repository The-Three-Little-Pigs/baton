// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthTransition)
final authTransitionProvider = AuthTransitionProvider._();

final class AuthTransitionProvider
    extends $NotifierProvider<AuthTransition, bool> {
  AuthTransitionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authTransitionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authTransitionHash();

  @$internal
  @override
  AuthTransition create() => AuthTransition();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$authTransitionHash() => r'38414c081f83192dfc2f44c80dd57d5b2136a52f';

abstract class _$AuthTransition extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(UserNotifier)
final userProvider = UserNotifierProvider._();

final class UserNotifierProvider
    extends $StreamNotifierProvider<UserNotifier, entity.User?> {
  UserNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userNotifierHash();

  @$internal
  @override
  UserNotifier create() => UserNotifier();
}

String _$userNotifierHash() => r'a97ed6a6903c2637208fada3e54d16fb0c399ad9';

abstract class _$UserNotifier extends $StreamNotifier<entity.User?> {
  Stream<entity.User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<entity.User?>, entity.User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<entity.User?>, entity.User?>,
              AsyncValue<entity.User?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
