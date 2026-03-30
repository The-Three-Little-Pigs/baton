import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/models/entities/appointment_data.dart';
import 'package:baton/models/enum/appointment_status.dart';
import 'package:baton/views/chat_detail/viewmodel/has_written_review_provider.dart';
import 'package:baton/views/chat_detail/dialog/apponitment_bottom_sheet.dart';
import 'package:baton/views/chat_detail/viewmodel/chat_detail_notifier.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/product_detail/viewmodel/author_notifier.dart';
import 'package:baton/views/widgets/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:baton/views/product_detail/viewmodel/product_detail_page_view_model.dart';
import 'package:baton/core/utils/ui/app_snackbar.dart';

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
    final otherUserAsync = ref.watch(
      authorProvider(otherUserId),
    ); // ✅ 상대방 유저 정보 구독

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 6),
      child: chatRoomAsync.when(
        data: (room) {
          if (room == null) return const SizedBox.shrink();
          final opponentName =
              otherUserAsync.value?.nickname ?? '상대방'; // ✅ 닉네임 추출

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
              // padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // color: currentStatus == AppointmentStatus.confirmed
                //     ? Colors.green.shade50
                //     : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () async {
                          if (room.activeAppointmentId != null) {
                            final shouldCancel = await showDialog<bool>(
                              context: context,
                              builder: (context) => CommonDialog(
                                title: '약속 취소',
                                content:
                                    '정말 약속을 취소하시겠습니까?\n취소 시 상품이 다시 판매중으로 변경됩니다.',
                                leftText: '아니오',
                                rightText: '네',
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
                              '약속 취소',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (currentStatus != AppointmentStatus.confirmed) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Material(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () =>
                              AppointmentBottomSheet.showAppointmentDialog(
                            context,
                            initialDateTime: room.appointmentDateTime,
                          ),
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
                                '날짜 조정',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
          if (currentStatus == AppointmentStatus.completed) {
            final postAsync = ref.watch(
              productDetailPageViewModelProvider(postId),
            );
            // 현재 사용자가 이미 후기를 작성했는지 확인
            final hasWrittenAsync = ref.watch(
              hasWrittenReviewProvider(roomId: roomId, writerId: myUserId),
            );

            return postAsync.maybeWhen(
              data: (post) {
                // 데이터를 가져오는 중에는 깜빡임을 방지하기 위해 빈 공간 또는 로딩 표시
                if (hasWrittenAsync.isLoading) {
                  return const SizedBox(height: 36);
                }

                final hasWritten = hasWrittenAsync.value ?? false;
                return SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: Material(
                    color: hasWritten
                        ? Colors.grey.shade300
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      // 이미 작성한 경우 터치 안되게 null 처리
                      onTap: hasWritten
                          ? null
                          : () {
                              context.push(
                                '/review/write',
                                extra: {
                                  'opponentName':
                                      opponentName, // ✅ UID 대신 닉네임 전달
                                  'receiverId': otherUserId,
                                  'postId': postId,
                                  'roomId': roomId,
                                  'productTitle': post.title,
                                  'productPrice': post.salePrice.toString(),
                                  'productImageUrl': post.imageUrls.isNotEmpty
                                      ? post.imageUrls[0]
                                      : null,
                                  'confirmedAt': room.confirmedAt,
                                },
                              );
                            },
                      child: Container(
                        height: 44, // 버튼 높이 명시적 지정
                        alignment: Alignment.center,
                        child: Text(
                          hasWritten ? '후기 작성 완료' : '후기 작성하기',
                          style: TextStyle(
                            color: hasWritten
                                ? Colors.grey.shade600
                                : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
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
                  AppSnackBar.show(context, errorMessage);
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
                      color: AppColors.textSecondary,
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
