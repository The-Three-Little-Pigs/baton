import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/models/entities/appointment_data.dart';
import 'package:baton/models/enum/appointment_status.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/chat_detail/dialog/apponitment_bottom_sheet.dart';
import 'package:baton/views/chat_detail/viewmodel/chat_detail_notifier.dart';
import 'package:baton/views/widgets/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AppointmentButton extends ConsumerWidget {
  const AppointmentButton({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUserId = ref.watch(userProvider).value?.uid ?? '';
    final parts = roomId.split('_');
    final otherUserId = (parts.length >= 2)
        ? (parts[0] == myUserId ? parts[1] : parts[0])
        : '';
    final postId = parts.length >= 3 ? parts[2] : '';
    final chatRoomAsync = ref.watch(chatRoomStreamProvider(roomId));
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 6),
      child: chatRoomAsync.when(
        data: (room) {
          if (room == null) return const SizedBox.shrink();
          AppointmentStatus? currentStatus;
          if (room.appointmentStatus != null) {
            currentStatus = AppointmentStatus.values.firstWhere(
              (e) =>
                  e.label == room.appointmentStatus ||
                  e.name == room.appointmentStatus,
              orElse: () => AppointmentStatus.cancelled,
            );
          }
          if (currentStatus == AppointmentStatus.pending ||
              currentStatus == AppointmentStatus.confirmed) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: currentStatus == AppointmentStatus.confirmed
                    ? Colors.green.shade50
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Expanded(
                  //   child: Text(
                  //     currentStatus == AppointmentStatus.confirmed
                  //         ? '✅ ${room.appointmentDateTime != null ? DateFormat('MM/dd (E) a h:mm').format(room.appointmentDateTime!) : ''} 약속 확정'
                  //         : '⏳ 상대방의 수락 확인 중',
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w600,
                  //       color: currentStatus == AppointmentStatus.confirmed
                  //           ? Colors.green.shade700
                  //           : AppColors.textTertiary,
                  //     ),
                  //   ),
                  // ),
                  OutlinedButton(
                    // 🔥 [취소 기능 연동] 실수 방지를 위해 다이얼로그 모달 먼저 띄우기
                    onPressed: () async {
                      if (room.activeAppointmentId != null) {
                        final shouldCancel = await showDialog<bool>(
                          context: context,
                          builder: (context) => CommonDialog(
                            title: '약속 취소',
                            content:
                                '정말 약속을 취소하시겠습니까?\n취소 시 상품이 다시 판매중으로 변경됩니다.',
                            leftText: '아니오',
                            rightText: '네, 취소합니다',
                            onLeftTap: () => Navigator.pop(context, false),
                            onRightTap: () => Navigator.pop(context, true),
                            rightBackgroundColor: AppColors.primary,
                          ),
                        );
                        if (shouldCancel == true) {
                          ref
                              .read(chatDetailProvider(roomId).notifier)
                              .cancelAppointment(
                                roomId,
                                room.activeAppointmentId!,
                                postId,
                              );
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () =>
                        AppointmentBottomSheet.showAppointmentDialog(
                          context,
                          initialDateTime: room.appointmentDateTime,
                        ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text('조정', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            );
          }
          if (currentStatus == AppointmentStatus.completed) {
            return const SizedBox.shrink();
          }
          return Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () async {
                final result =
                    await AppointmentBottomSheet.showAppointmentDialog(context);
                if (result == null) return;
                final DateTime selectedDate = result['dateTime'];
                final String method = result['method'];
                final appointment = AppointmentData(
                  appointmentId: '', // 레포지토리가 생성
                  dateTime: selectedDate,
                  method: method,
                  status: AppointmentStatus.pending,
                  proposeBy: myUserId,
                );
                final bool isRoomExist = chatRoomAsync.value != null;
                final errorMessage = await ref
                    .read(chatDetailProvider(roomId).notifier)
                    .sendAppointmentMessage(
                      roomId,
                      otherUserId,
                      appointment,
                      isRoomExist,
                    );
                if (errorMessage != null && context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(errorMessage)));
                }
              },

              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                height: 36,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Center(
                  child: Text(
                    '약속하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}
