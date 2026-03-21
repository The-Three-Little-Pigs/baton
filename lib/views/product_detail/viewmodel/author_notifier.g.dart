// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthorNotifier)
final authorProvider = AuthorNotifierFamily._();

final class AuthorNotifierProvider
    extends $AsyncNotifierProvider<AuthorNotifier, User> {
  AuthorNotifierProvider._({
    required AuthorNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'authorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$authorNotifierHash();

  @override
  String toString() {
    return r'authorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AuthorNotifier create() => AuthorNotifier();

  @override
  bool operator ==(Object other) {
    return other is AuthorNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$authorNotifierHash() => r'422fa75bd0719fdb765f5f102db5b82463b6652b';

final class AuthorNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AuthorNotifier,
          AsyncValue<User>,
          User,
          FutureOr<User>,
          String
        > {
  AuthorNotifierFamily._()
    : super(
        retry: null,
        name: r'authorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AuthorNotifierProvider call(String authorId) =>
      AuthorNotifierProvider._(argument: authorId, from: this);

  @override
  String toString() => r'authorProvider';
}

abstract class _$AuthorNotifier extends $AsyncNotifier<User> {
  late final _$args = ref.$arg as String;
  String get authorId => _$args;

  FutureOr<User> build(String authorId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User>, User>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User>, User>,
              AsyncValue<User>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
