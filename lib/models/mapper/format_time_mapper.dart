/// 시간을 포맷팅하는 함수
String formatTime(String time) {
  if (time.isEmpty) return '';

  try {
    final date = DateTime.parse(time);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return '방금 전';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}일 전';
    } else {
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    }
  } catch (e) {
    return ''; // Parsing failed, return empty or default string
  }
}
