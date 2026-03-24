import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/models/entities/appointment_data.dart';
import 'package:baton/models/enum/appointment_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentData data;
  final bool isMyCard;
  final VoidCallback onConfirm;
  final VoidCallback onAdjust;
  final VoidCallback? onCancel;
  final VoidCallback? onComplete;
  final bool hasConfirmed;
  final String opponentNickname;

  const AppointmentCard({
    super.key,
    required this.data,
    required this.isMyCard,
    required this.onConfirm,
    required this.onAdjust,
    this.onCancel,
    this.onComplete,
    this.hasConfirmed = false,
    required this.opponentNickname,
  });

  @override
  Widget build(BuildContext context) {
    final isInactive =
        data.status == AppointmentStatus.replaced ||
        data.status == AppointmentStatus.cancelled;
    final isCancelled = data.status == AppointmentStatus.cancelled;
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        crossAxisAlignment: isMyCard
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          _builderStatusBadge(isInactive),
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.623,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isInactive ? Colors.grey.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isInactive
                      ? Colors.grey.shade300
                      : AppColors.secondary,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    DateFormat('MM월 dd일 a h:mm', 'ko_KR').format(data.dateTime),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: null,
                      color: isInactive ? Colors.grey.shade300 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data.method,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isInactive
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  if (data.status == AppointmentStatus.pending &&
                      !isMyCard) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              '약속 확정',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: onAdjust,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                            ),
                            child: const Text(
                              '날짜 조정',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (data.status == AppointmentStatus.confirmed) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 12),
                    Builder(
                      builder: (context) {
                        // 시간에 따른 상태 변화 렌더링
                        final isTimePassed = data.dateTime.isBefore(
                          DateTime.now(),
                        );
                        if (isTimePassed) {
                          if (hasConfirmed) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                '상대방의 🤝거래 확정을 기다리는 중입니다...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: onComplete, // 누르면 뷰모델 찌름
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                '거래 확정하기',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                        } else {
                          // 아직 시간이 안 지났다면 '약속 취소' 노출
                          return OutlinedButton(
                            onPressed: onCancel,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('약속 취소'),
                          );
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // lib/views/chat_detail/widgets/appointment_card.dart

  Widget _builderStatusBadge(bool isInactive) {
    String title;
    String description;
    Color barColor = Colors.black; // 기본은 검은색 바

    // 상태에 따른 타이틀 및 설명 정의
    switch (data.status) {
      case AppointmentStatus.pending:
        title = '약속 신청';
        description = isMyCard
            ? '$opponentNickname 님에게 약속 신청을 보냈습니다.'
            : '$opponentNickname 님이 약속 신청을 하였습니다.';
        barColor = AppColors.primary;
        break;
      case AppointmentStatus.confirmed:
        title = '약속 확정';
        description = isMyCard
            ? '$opponentNickname 님이 약속을 수락했습니다.' // 제안자(나)의 화면
            : '약속을 확정했습니다!';
        barColor = Colors.green;
        break;
      case AppointmentStatus.cancelled:
        title = '약속 취소';
        description = '약속이 취소되었습니다.';
        barColor = Colors.red;
        break;
      case AppointmentStatus.replaced:
        title = '약속 변경';
        description = '약속이 변경되었습니다.';
        barColor = Colors.orange;
        break;
      case AppointmentStatus.completed:
        title = '거래 확정';
        description = '거래가 완료되었습니다.';
        barColor = Colors.green;
        break;
      default:
        title = '약속 알림';
        description = '약속 상태가 업데이트되었습니다.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // [수정] 내 카드가 아닐 때만(상상대방이 보낸 약속일 때만) 타이틀 노출
        if (!isMyCard) ...[
          Row(
            mainAxisSize: MainAxisSize.min, // 필요한 만큼만 공간 차지
            children: [
              Container(
                width: 3.5,
                height: 18,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isInactive ? Colors.grey : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        // 2. 설명 문구 (본인이 보낸 경우에도 항상 노출)
        Text(
          description,
          textAlign: isMyCard
              ? TextAlign.end
              : TextAlign.start, // 텍스트 정렬 방향도 맞춰줍니다.
          style: TextStyle(
            fontSize: 14,
            color: isInactive ? Colors.grey.shade400 : Colors.grey.shade600,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
