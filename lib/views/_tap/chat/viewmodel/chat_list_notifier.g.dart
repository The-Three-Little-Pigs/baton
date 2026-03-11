// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatListNotifier)
final chatListProvider = ChatListNotifierProvider._();

final class ChatListNotifierProvider
    extends $StreamNotifierProvider<ChatListNotifier, List<Chatroom>> {
  ChatListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatListNotifierHash();

  @$internal
  @override
  ChatListNotifier create() => ChatListNotifier();
}

String _$chatListNotifierHash() => r'9b6c075b16d66368646a44720cf4d8656ba1caa3';

abstract class _$ChatListNotifier extends $StreamNotifier<List<Chatroom>> {
  Stream<List<Chatroom>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Chatroom>>, List<Chatroom>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Chatroom>>, List<Chatroom>>,
              AsyncValue<List<Chatroom>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
