enum MessageType {
  text(value: "text"),
  image(value: "image");

  final String value;

  const MessageType({required this.value});
}
