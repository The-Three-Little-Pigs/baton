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
          Stream<List<ReviewData>>
        >
    with $FutureModifier<List<ReviewData>>, $StreamProvider<List<ReviewData>> {
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
  $StreamProviderElement<List<ReviewData>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ReviewData>> create(Ref ref) {
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

String _$receivedReviewsHash() => r'd2fbfc69de4056d79e30c36b5945f0c764267065';

final class ReceivedReviewsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ReviewData>>, String> {
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
          Stream<List<ReviewData>>
        >
    with $FutureModifier<List<ReviewData>>, $StreamProvider<List<ReviewData>> {
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
  $StreamProviderElement<List<ReviewData>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ReviewData>> create(Ref ref) {
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

String _$sentReviewsHash() => r'd95d034596cd1c5dd467bfc9ffaa734ecd747163';

final class SentReviewsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ReviewData>>, String> {
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
