enum ChatStatus {
  all('전체'),
  purchase('구매'),
  sales('판매'),
  reserved('예약'),
  completed('완료');

  final String name;

  const ChatStatus(this.name);
}
