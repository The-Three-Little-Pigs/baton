import 'package:flutter/material.dart';

class SubTitle extends StatelessWidget {
  const SubTitle({super.key, required this.title, this.required = false});

  final String title;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        if (required) const Text("*", style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
