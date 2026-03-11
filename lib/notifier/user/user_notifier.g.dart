// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserNotifier)
final userProvider = UserNotifierProvider._();

final class UserNotifierProvider
    extends $AsyncNotifierProvider<UserNotifier, entity.User?> {
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

String _$userNotifierHash() => r'b355b48f8e8a78cfa4b8af195c622887ef2a328f';

abstract class _$UserNotifier extends $AsyncNotifier<entity.User?> {
  FutureOr<entity.User?> build();
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
