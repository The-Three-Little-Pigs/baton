// lib/views/_tap/chat/viewmodel/selected_chat_status_provider.dart
import 'package:baton/models/enum/chat_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_chat_status_provider.g.dart';

@riverpod
class SelectedChatStatus extends _$SelectedChatStatus {
  @override
  ChatStatus build() => ChatStatus.all;

  void setStatus(ChatStatus status) {
    state = (state == status) ? ChatStatus.all : status;
  }
}
