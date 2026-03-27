// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatDetailNotifier)
final chatDetailProvider = ChatDetailNotifierFamily._();

final class ChatDetailNotifierProvider
    extends $StreamNotifierProvider<ChatDetailNotifier, List<Message>> {
  ChatDetailNotifierProvider._({
    required ChatDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatDetailNotifierHash();

  @override
  String toString() {
    return r'chatDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatDetailNotifier create() => ChatDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is ChatDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatDetailNotifierHash() =>
    r'c6addd0fdd4f5d5477d611dcd3b6b7b4be24e0d4';

final class ChatDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatDetailNotifier,
          AsyncValue<List<Message>>,
          List<Message>,
          Stream<List<Message>>,
          String
        > {
  ChatDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'chatDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatDetailNotifierProvider call(String roomId) =>
      ChatDetailNotifierProvider._(argument: roomId, from: this);

  @override
  String toString() => r'chatDetailProvider';
}

abstract class _$ChatDetailNotifier extends $StreamNotifier<List<Message>> {
  late final _$args = ref.$arg as String;
  String get roomId => _$args;

  Stream<List<Message>> build(String roomId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Message>>, List<Message>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Message>>, List<Message>>,
              AsyncValue<List<Message>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(chatRoomStream)
final chatRoomStreamProvider = ChatRoomStreamFamily._();

final class ChatRoomStreamProvider
    extends
        $FunctionalProvider<AsyncValue<Chatroom?>, Chatroom?, Stream<Chatroom?>>
    with $FutureModifier<Chatroom?>, $StreamProvider<Chatroom?> {
  ChatRoomStreamProvider._({
    required ChatRoomStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRoomStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRoomStreamHash();

  @override
  String toString() {
    return r'chatRoomStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Chatroom?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Chatroom?> create(Ref ref) {
    final argument = this.argument as String;
    return chatRoomStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRoomStreamHash() => r'e6eb3fa4048b8c4f708cb157f3c6436905c99736';

final class ChatRoomStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Chatroom?>, String> {
  ChatRoomStreamFamily._()
    : super(
        retry: null,
        name: r'chatRoomStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatRoomStreamProvider call(String roomId) =>
      ChatRoomStreamProvider._(argument: roomId, from: this);

  @override
  String toString() => r'chatRoomStreamProvider';
}

@ProviderFor(chatMessageUiModel)
final chatMessageUiModelProvider = ChatMessageUiModelFamily._();

final class ChatMessageUiModelProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatMessageUiModel>>,
          AsyncValue<List<ChatMessageUiModel>>,
          AsyncValue<List<ChatMessageUiModel>>
        >
    with $Provider<AsyncValue<List<ChatMessageUiModel>>> {
  ChatMessageUiModelProvider._({
    required ChatMessageUiModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatMessageUiModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMessageUiModelHash();

  @override
  String toString() {
    return r'chatMessageUiModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<ChatMessageUiModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<ChatMessageUiModel>> create(Ref ref) {
    final argument = this.argument as String;
    return chatMessageUiModel(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ChatMessageUiModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<ChatMessageUiModel>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessageUiModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMessageUiModelHash() =>
    r'ac5896a86540bb20600d5e1e0ba70c60de3282e5';

final class ChatMessageUiModelFamily extends $Family
    with
        $FunctionalFamilyOverride<
          AsyncValue<List<ChatMessageUiModel>>,
          String
        > {
  ChatMessageUiModelFamily._()
    : super(
        retry: null,
        name: r'chatMessageUiModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatMessageUiModelProvider call(String roomId) =>
      ChatMessageUiModelProvider._(argument: roomId, from: this);

  @override
  String toString() => r'chatMessageUiModelProvider';
}
