import 'package:flutter/material.dart';

class CustomPopupBtn extends StatelessWidget {
  final Widget child; // 클릭할 대상 (버튼, 아이콘 등)
  final List<PopupMenuEntry> items; // 보여줄 메뉴 리스트
  final Function(dynamic)? onSelected; // 아이템 선택 시 콜백

  const CustomPopupBtn({
    super.key,
    required this.child,
    required this.items,
    this.onSelected,
  });

  void _showCustomMenu(BuildContext context) async {
    // 1. 현재 클릭된 버튼의 위치와 크기 정보를 가져옴
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    // 2. 버튼의 절대 좌표를 상대 좌표(RelativeRect)로 변환
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    // 3. 메뉴 표시
    final result = await showMenu(
      context: context,
      position: position,
      items: items,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    // 4. 결과값 처리
    if (result != null && onSelected != null) {
      onSelected!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => _showCustomMenu(context), child: child);
  }
}
