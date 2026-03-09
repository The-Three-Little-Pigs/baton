// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similar_product_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SimilarProductNotifier)
final similarProductProvider = SimilarProductNotifierFamily._();

final class SimilarProductNotifierProvider
    extends $AsyncNotifierProvider<SimilarProductNotifier, List<Post>> {
  SimilarProductNotifierProvider._({
    required SimilarProductNotifierFamily super.from,
    required (Category, String) super.argument,
  }) : super(
         retry: null,
         name: r'similarProductProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$similarProductNotifierHash();

  @override
  String toString() {
    return r'similarProductProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SimilarProductNotifier create() => SimilarProductNotifier();

  @override
  bool operator ==(Object other) {
    return other is SimilarProductNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$similarProductNotifierHash() =>
    r'c6852fa62bc4ef6762b8302ffe6500b76a7b5d95';

final class SimilarProductNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SimilarProductNotifier,
          AsyncValue<List<Post>>,
          List<Post>,
          FutureOr<List<Post>>,
          (Category, String)
        > {
  SimilarProductNotifierFamily._()
    : super(
        retry: null,
        name: r'similarProductProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SimilarProductNotifierProvider call(
    Category category,
    String currentPostId,
  ) => SimilarProductNotifierProvider._(
    argument: (category, currentPostId),
    from: this,
  );

  @override
  String toString() => r'similarProductProvider';
}

abstract class _$SimilarProductNotifier extends $AsyncNotifier<List<Post>> {
  late final _$args = ref.$arg as (Category, String);
  Category get category => _$args.$1;
  String get currentPostId => _$args.$2;

  FutureOr<List<Post>> build(Category category, String currentPostId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Post>>, List<Post>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Post>>, List<Post>>,
              AsyncValue<List<Post>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
