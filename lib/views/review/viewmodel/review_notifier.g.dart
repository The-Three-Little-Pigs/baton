// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(receivedReviews)
final receivedReviewsProvider = ReceivedReviewsFamily._();

final class ReceivedReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReviewData>>,
          List<ReviewData>,
          FutureOr<List<ReviewData>>
        >
    with $FutureModifier<List<ReviewData>>, $FutureProvider<List<ReviewData>> {
  ReceivedReviewsProvider._({
    required ReceivedReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'receivedReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$receivedReviewsHash();

  @override
  String toString() {
    return r'receivedReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ReviewData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReviewData>> create(Ref ref) {
    final argument = this.argument as String;
    return receivedReviews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReceivedReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$receivedReviewsHash() => r'1e3f2721e9924dbffe77514d740f806e83ecc0fe';

final class ReceivedReviewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ReviewData>>, String> {
  ReceivedReviewsFamily._()
    : super(
        retry: null,
        name: r'receivedReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReceivedReviewsProvider call(String userId) =>
      ReceivedReviewsProvider._(argument: userId, from: this);

  @override
  String toString() => r'receivedReviewsProvider';
}

@ProviderFor(sentReviews)
final sentReviewsProvider = SentReviewsFamily._();

final class SentReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReviewData>>,
          List<ReviewData>,
          FutureOr<List<ReviewData>>
        >
    with $FutureModifier<List<ReviewData>>, $FutureProvider<List<ReviewData>> {
  SentReviewsProvider._({
    required SentReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sentReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sentReviewsHash();

  @override
  String toString() {
    return r'sentReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ReviewData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReviewData>> create(Ref ref) {
    final argument = this.argument as String;
    return sentReviews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SentReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sentReviewsHash() => r'eca6631e6ee60c2b347b7647e91fa13b81c3fb2f';

final class SentReviewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ReviewData>>, String> {
  SentReviewsFamily._()
    : super(
        retry: null,
        name: r'sentReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SentReviewsProvider call(String userId) =>
      SentReviewsProvider._(argument: userId, from: this);

  @override
  String toString() => r'sentReviewsProvider';
}
