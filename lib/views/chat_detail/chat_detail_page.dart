import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  const ChatDetailPage({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Chat Detail')));
  }
}
