// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_page_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductDetailPageViewModel)
final productDetailPageViewModelProvider = ProductDetailPageViewModelFamily._();

final class ProductDetailPageViewModelProvider
    extends $StreamNotifierProvider<ProductDetailPageViewModel, Post> {
  ProductDetailPageViewModelProvider._({
    required ProductDetailPageViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productDetailPageViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDetailPageViewModelHash();

  @override
  String toString() {
    return r'productDetailPageViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProductDetailPageViewModel create() => ProductDetailPageViewModel();

  @override
  bool operator ==(Object other) {
    return other is ProductDetailPageViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailPageViewModelHash() =>
    r'fff8f2e38a8806ab21ca1f3e0162e7e845d2b4a5';

final class ProductDetailPageViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductDetailPageViewModel,
          AsyncValue<Post>,
          Post,
          Stream<Post>,
          String
        > {
  ProductDetailPageViewModelFamily._()
    : super(
        retry: null,
        name: r'productDetailPageViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductDetailPageViewModelProvider call(String postId) =>
      ProductDetailPageViewModelProvider._(argument: postId, from: this);

  @override
  String toString() => r'productDetailPageViewModelProvider';
}

abstract class _$ProductDetailPageViewModel extends $StreamNotifier<Post> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  Stream<Post> build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Post>, Post>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Post>, Post>,
              AsyncValue<Post>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
