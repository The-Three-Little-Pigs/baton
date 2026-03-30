enum ProductStatus {
  available("판매중"),
  sold("판매완료"),
  reserved("거래중");

  final String label;

  const ProductStatus(this.label);
}
