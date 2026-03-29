// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_chat_count_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productChatCount)
final productChatCountProvider = ProductChatCountFamily._();

final class ProductChatCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  ProductChatCountProvider._({
    required ProductChatCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productChatCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productChatCountHash();

  @override
  String toString() {
    return r'productChatCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as String;
    return productChatCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductChatCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productChatCountHash() => r'c7de443d07255999c3035a9519573af875e159ba';

final class ProductChatCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  ProductChatCountFamily._()
    : super(
        retry: null,
        name: r'productChatCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductChatCountProvider call(String postId) =>
      ProductChatCountProvider._(argument: postId, from: this);

  @override
  String toString() => r'productChatCountProvider';
}
