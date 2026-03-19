// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_chips_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategoryChipsNotifier)
final categoryChipsProvider = CategoryChipsNotifierProvider._();

final class CategoryChipsNotifierProvider
    extends $NotifierProvider<CategoryChipsNotifier, Set<Category>> {
  CategoryChipsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryChipsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryChipsNotifierHash();

  @$internal
  @override
  CategoryChipsNotifier create() => CategoryChipsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<Category> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<Category>>(value),
    );
  }
}

String _$categoryChipsNotifierHash() =>
    r'9c5c6221413bd77ea9905b77748b79c234771b80';

abstract class _$CategoryChipsNotifier extends $Notifier<Set<Category>> {
  Set<Category> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<Category>, Set<Category>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<Category>, Set<Category>>,
              Set<Category>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
