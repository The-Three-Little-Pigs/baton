import 'package:flutter/cupertino.dart';

class CupertinoModalPopUp extends StatelessWidget {
  const CupertinoModalPopUp({super.key, required this.actions});

  final List<Map<String, VoidCallback>> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoActionSheet(
        actions: actions.map((action) {
          return CupertinoActionSheetAction(
            onPressed: action.values.first,
            child: Text(
              action.keys.first,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "닫기",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
