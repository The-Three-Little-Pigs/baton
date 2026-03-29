import 'package:logger/logger.dart';

/// 앱 전역에서 사용할 로거 인스턴스
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // 일반 로그에서는 호출 경로 비활성화
    errorMethodCount: 8, // 에러 발생 시에만 호출 경로 표시
    lineLength: 120, // 줄 바꿈 길이
    colors: true, // 색상 사용 여부
    printEmojis: true, // 이모지 사용 여부
    dateTimeFormat: DateTimeFormat.dateAndTime, // 날짜 스트림 형식
  ),
);
