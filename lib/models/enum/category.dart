enum Category {
  fitness('헬스/피티'),
  course('수강권'),
  beauty('뷰티/에스테틱'),
  rental('대관'),
  yoga('요가/필라테스'),
  music('음악'),
  golf('골프'),
  resort('호텔/숙박'),
  etc('기타');

  final String displayName;
  const Category(this.displayName);
}
