import 'package:baton/views/widgets/complete_button.dart';
import 'package:flutter/material.dart';

class BottomChatBar extends StatelessWidget {
  const BottomChatBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        _FavoriteButton(),
        Expanded(
          child: CompleteButton(label: "채팅하기", onPressed: () {}),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox.square(
        dimension: 54,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Icon(
            Icons.favorite,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
