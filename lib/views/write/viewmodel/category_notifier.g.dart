// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategoryNotifier)
final categoryProvider = CategoryNotifierProvider._();

final class CategoryNotifierProvider
    extends $NotifierProvider<CategoryNotifier, CategoryState> {
  CategoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryNotifierHash();

  @$internal
  @override
  CategoryNotifier create() => CategoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryState>(value),
    );
  }
}

String _$categoryNotifierHash() => r'9e456d9e2296a97a5d5dade89c777c6a98917e15';

abstract class _$CategoryNotifier extends $Notifier<CategoryState> {
  CategoryState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CategoryState, CategoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CategoryState, CategoryState>,
              CategoryState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
