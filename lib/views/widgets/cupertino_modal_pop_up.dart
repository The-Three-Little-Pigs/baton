import 'package:flutter/cupertino.dart';

class CupertinoModalPopUp extends StatelessWidget {
  const CupertinoModalPopUp({super.key, required this.actions});

  final List<Map<String, VoidCallback>> actions;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: actions.map((action) {
        return CupertinoActionSheetAction(
          onPressed: action.values.first,
          child: Text(action.keys.first),
        );
      }).toList(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("닫기"),
      ),
    );
  }
}
