enum PostActionType {
  edit('게시글 수정'),
  report('신고하기'),
  delete('게시글 삭제');

  final String label;
  const PostActionType(this.label);
}
