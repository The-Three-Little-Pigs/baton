// import 'package:baton/core/theme/app_tokens/app_colors.dart';
// import 'package:baton/views/chat_detail/widgets/appointment_button.dart';
// import 'package:baton/views/chat_detail/widgets/chat_message_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// class AppointmentScrollArea extends StatefulWidget {
//   final String roomId;
//   const AppointmentScrollArea({super.key, required this.roomId});

//   @override
//   State<AppointmentScrollArea> createState() => _AppointmentScrollAreaState();
// }

// class _AppointmentScrollAreaState extends State<AppointmentScrollArea> {
//   bool _isAppointmentVisible = true;
//   bool _onScrollNotification(UserScrollNotification notification) {
//     if (notification.direction == ScrollDirection.forward) {
//       if (_isAppointmentVisible) setState(() => _isAppointmentVisible = false);
//     } else if (notification.direction == ScrollDirection.reverse) {
//       if (!_isAppointmentVisible) setState(() => _isAppointmentVisible = true);
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         AnimatedSize(
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.easeInOut,
//           child: Container(
//             height: _isAppointmentVisible ? null : 0.0,
//             decoration: BoxDecoration(),
//             clipBehavior: Clip.hardEdge,
//             child: ClipRRect(child: const AppointmentButton()),
//           ),
//         ),
//         const Divider(color: AppColors.secondary, thickness: 1),
//         Expanded(
//           child: NotificationListener<UserScrollNotification>(
//             onNotification: _onScrollNotification,
//             child: ChatMessageList(roomId: widget.roomId),
//           ),
//         ),
//       ],
//     );
//   }
// }
