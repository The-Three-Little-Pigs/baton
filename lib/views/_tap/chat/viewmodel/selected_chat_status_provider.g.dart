// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_chat_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedChatStatus)
final selectedChatStatusProvider = SelectedChatStatusProvider._();

final class SelectedChatStatusProvider
    extends $NotifierProvider<SelectedChatStatus, ChatStatus> {
  SelectedChatStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedChatStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedChatStatusHash();

  @$internal
  @override
  SelectedChatStatus create() => SelectedChatStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatStatus>(value),
    );
  }
}

String _$selectedChatStatusHash() =>
    r'981b03ce212b898c4b3ade716d19867ef7c5d722';

abstract class _$SelectedChatStatus extends $Notifier<ChatStatus> {
  ChatStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChatStatus, ChatStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatStatus, ChatStatus>,
              ChatStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
