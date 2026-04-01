enum MessageType {
  text("텍스트"),
  image("이미지"),
  system("시스템"),
  appointment("약속");

  final String label;

  const MessageType(this.label);
}
