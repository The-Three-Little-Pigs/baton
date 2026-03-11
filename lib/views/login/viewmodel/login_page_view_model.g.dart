// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_page_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginPageViewModel)
final loginPageViewModelProvider = LoginPageViewModelProvider._();

final class LoginPageViewModelProvider
    extends $AsyncNotifierProvider<LoginPageViewModel, LoginStatus?> {
  LoginPageViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginPageViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginPageViewModelHash();

  @$internal
  @override
  LoginPageViewModel create() => LoginPageViewModel();
}

String _$loginPageViewModelHash() =>
    r'54627287fbb456332e21482a4739bc310153f1d4';

abstract class _$LoginPageViewModel extends $AsyncNotifier<LoginStatus?> {
  FutureOr<LoginStatus?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LoginStatus?>, LoginStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoginStatus?>, LoginStatus?>,
              AsyncValue<LoginStatus?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
