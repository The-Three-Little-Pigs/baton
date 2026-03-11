// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_action_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatRoomActionNotifier)
final chatRoomActionProvider = ChatRoomActionNotifierProvider._();

final class ChatRoomActionNotifierProvider
    extends $NotifierProvider<ChatRoomActionNotifier, void> {
  ChatRoomActionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRoomActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRoomActionNotifierHash();

  @$internal
  @override
  ChatRoomActionNotifier create() => ChatRoomActionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$chatRoomActionNotifierHash() =>
    r'9096c42242ab82df22336e02ad81e74dc279e8e0';

abstract class _$ChatRoomActionNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
