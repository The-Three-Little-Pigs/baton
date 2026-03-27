// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'has_written_review_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 특정 채팅방에서 현재 사용자가 이미 후기를 작성했는지 확인합니다.
///
/// - [roomId]: 확인할 채팅방 ID
/// - [writerId]: 확인할 작성자 UID (보통 현재 로그인 사용자)
///
/// 에러 발생 시 보수적으로 `false`를 반환하여 버튼을 활성 상태로 유지합니다.

@ProviderFor(hasWrittenReview)
final hasWrittenReviewProvider = HasWrittenReviewFamily._();

/// 특정 채팅방에서 현재 사용자가 이미 후기를 작성했는지 확인합니다.
///
/// - [roomId]: 확인할 채팅방 ID
/// - [writerId]: 확인할 작성자 UID (보통 현재 로그인 사용자)
///
/// 에러 발생 시 보수적으로 `false`를 반환하여 버튼을 활성 상태로 유지합니다.

final class HasWrittenReviewProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 특정 채팅방에서 현재 사용자가 이미 후기를 작성했는지 확인합니다.
  ///
  /// - [roomId]: 확인할 채팅방 ID
  /// - [writerId]: 확인할 작성자 UID (보통 현재 로그인 사용자)
  ///
  /// 에러 발생 시 보수적으로 `false`를 반환하여 버튼을 활성 상태로 유지합니다.
  HasWrittenReviewProvider._({
    required HasWrittenReviewFamily super.from,
    required ({String roomId, String writerId}) super.argument,
  }) : super(
         retry: null,
         name: r'hasWrittenReviewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hasWrittenReviewHash();

  @override
  String toString() {
    return r'hasWrittenReviewProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as ({String roomId, String writerId});
    return hasWrittenReview(
      ref,
      roomId: argument.roomId,
      writerId: argument.writerId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HasWrittenReviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hasWrittenReviewHash() => r'24fea1e0b4a978dd702c919c277c61e6ca670682';

/// 특정 채팅방에서 현재 사용자가 이미 후기를 작성했는지 확인합니다.
///
/// - [roomId]: 확인할 채팅방 ID
/// - [writerId]: 확인할 작성자 UID (보통 현재 로그인 사용자)
///
/// 에러 발생 시 보수적으로 `false`를 반환하여 버튼을 활성 상태로 유지합니다.

final class HasWrittenReviewFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({String roomId, String writerId})
        > {
  HasWrittenReviewFamily._()
    : super(
        retry: null,
        name: r'hasWrittenReviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 특정 채팅방에서 현재 사용자가 이미 후기를 작성했는지 확인합니다.
  ///
  /// - [roomId]: 확인할 채팅방 ID
  /// - [writerId]: 확인할 작성자 UID (보통 현재 로그인 사용자)
  ///
  /// 에러 발생 시 보수적으로 `false`를 반환하여 버튼을 활성 상태로 유지합니다.

  HasWrittenReviewProvider call({
    required String roomId,
    required String writerId,
  }) => HasWrittenReviewProvider._(
    argument: (roomId: roomId, writerId: writerId),
    from: this,
  );

  @override
  String toString() => r'hasWrittenReviewProvider';
}
