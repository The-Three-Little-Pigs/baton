/// 금액을 세 자리마다 콤마(,)를 찍어 포맷팅하는 함수
String formatCurrency(num amount) {
  // 가격의 경우 대개 소수점이 없거나 무시하므로 정수로 변환하여 처리합니다.
  final str = amount.truncate().toString();

  // 정규식을 활용하여 세 자리마다 콤마를 추가합니다.
  return str.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
}
