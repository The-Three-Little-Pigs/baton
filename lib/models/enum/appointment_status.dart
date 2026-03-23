enum AppointmentStatus {
  pending('대기중'),
  confirmed('확정'),
  replaced('대체됨'),
  cancelled('취소'),
  sellerConfirmed('판매자확정'),
  completed('거래완료');

  final String label;
  const AppointmentStatus(this.label);
}
