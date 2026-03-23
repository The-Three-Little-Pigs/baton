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

  const AppointmentCard({
    super.key,
    required this.data,
    required this.isMyCard,
    required this.onConfirm,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    final isInactive =
        data.status == AppointmentStatus.replaced ||
        data.status == AppointmentStatus.cancelled;
    final isCancelled = data.status == AppointmentStatus.cancelled;
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 20),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.623,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isInactive ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isInactive ? Colors.grey.shade300 : AppColors.primary,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _builderStatusBadge(isInactive),
              const SizedBox(height: 12),
              Text(
                DateFormat('MM월 dd일 a h:mm', 'ko_KR').format(data.dateTime),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: isCancelled ? TextDecoration.lineThrough : null,
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
              if (data.status == AppointmentStatus.pending && !isMyCard) ...[
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _builderStatusBadge(bool isInactive) {
    Color badgeColor;
    String badgeText;

    switch (data.status) {
      case AppointmentStatus.pending:
        badgeColor = isMyCard ? Colors.grey.shade500 : AppColors.primary;
        badgeText = isMyCard ? '답변 대기중' : '약속 요청이 왔어요';
        break;
      case AppointmentStatus.confirmed:
        badgeColor = Colors.green;
        badgeText = '✅ 약속 확정됨';
        break;
      case AppointmentStatus.replaced: // 날짜가 밀려서 이전 카드가 된 경우
        badgeColor = Colors.grey;
        badgeText = '⏱️ 시간 변경됨'; // 🔥 '거래 완료'에서 변경 완료!
        break;
      case AppointmentStatus.completed:
        badgeColor = Colors.grey;
        badgeText = '거래 완료';
        break;
      case AppointmentStatus.cancelled:
        badgeColor = Colors.grey;
        badgeText = '취소됨';
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = '상태 알수없음';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isInactive ? Colors.transparent : badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badgeText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isInactive ? Colors.grey.shade400 : badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
