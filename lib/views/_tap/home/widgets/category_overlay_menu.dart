// import 'package:baton/models/enum/category.dart';
// import 'package:flutter/material.dart';

// /// OverlayPortal을 사용하여 화면 전체 가로폭을 차지하는 카테고리 메뉴입니다.
// class CategoryOverlayMenu extends StatefulWidget {
//   const CategoryOverlayMenu({super.key});

//   @override
//   State<CategoryOverlayMenu> createState() => _CategoryOverlayMenuState();
// }

// class _CategoryOverlayMenuState extends State<CategoryOverlayMenu> {
//   final _overlayController = OverlayPortalController();
//   final _link = LayerLink();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final size = MediaQuery.of(context).size;

//     return CompositedTransformTarget(
//       link: _link,
//       child: OverlayPortal(
//         controller: _overlayController,
//         overlayChildBuilder: (context) {
//           // 배경 터치 시 닫기 위한 레이어
//           return Stack(
//             children: [
//               GestureDetector(
//                 onTap: _overlayController.hide,
//                 child: Container(color: Colors.black.withOpacity(0.1)),
//               ),
//               CompositedTransformFollower(
//                 link: _link,
//                 showWhenUnlinked: false,
//                 targetAnchor: Alignment.bottomCenter,
//                 followerAnchor: Alignment.topCenter,
//                 child: Container(
//                   width: size.width,
//                   constraints: BoxConstraints(maxHeight: size.height * 0.6),
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.surface,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // 1.Divider 추가 (상단 구분선)
//                       const Divider(height: 1, thickness: 1),

//                       const SizedBox(height: 8),

//                       // 2.카테고리 목록 리스트
//                       Flexible(
//                         child: ListView.separated(
//                           shrinkWrap: true,
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           itemCount: Category.values.length,
//                           separatorBuilder: (context, index) => const Divider(
//                             height: 1,
//                             indent: 16,
//                             endIndent: 16,
//                           ),
//                           itemBuilder: (context, index) {
//                             final category = Category.values[index];
//                             return ListTile(
//                               title: Text(
//                                 category.displayName,
//                                 style: const TextStyle(fontSize: 15),
//                               ),
//                               onTap: () {
//                                 // 카테고리 선택 로직 수행
//                                 _overlayController.hide();
//                               },
//                             );
//                           },
//                         ),
//                       ),

//                       // 3.하단 Divider 및 닫기 버튼
//                       const Divider(height: 1, thickness: 1),
//                       SizedBox(
//                         width: double.infinity,
//                         child: TextButton(
//                           onPressed: _overlayController.hide,
//                           child: const Text("닫기"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//         child: OutlinedButton.icon(
//           onPressed: _overlayController.toggle,
//           icon: const Icon(Icons.tune),
//           label: const Text("카테고리 필터"),
//           style: OutlinedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(999),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
