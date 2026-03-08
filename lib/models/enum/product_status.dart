enum ProductStatus {
  available('판매중'),
  sold('판매완료'),
  reserved('예약중');

  final String name;

  const ProductStatus(this.name);
}
