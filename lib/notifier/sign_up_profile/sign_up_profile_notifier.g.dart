// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignUpProfile)
final signUpProfileProvider = SignUpProfileProvider._();

final class SignUpProfileProvider
    extends $NotifierProvider<SignUpProfile, SignUpProfileState> {
  SignUpProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signUpProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signUpProfileHash();

  @$internal
  @override
  SignUpProfile create() => SignUpProfile();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignUpProfileState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignUpProfileState>(value),
    );
  }
}

String _$signUpProfileHash() => r'cb13f4d56db58561b79f3edae4db7821ed1d69f9';

abstract class _$SignUpProfile extends $Notifier<SignUpProfileState> {
  SignUpProfileState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SignUpProfileState, SignUpProfileState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SignUpProfileState, SignUpProfileState>,
              SignUpProfileState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
