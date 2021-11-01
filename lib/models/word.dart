class Word {
  bool? complete = false;
  dynamic explains;
  int? id;
  String keyword;

  Word({
    this.complete,
    this.explains,
    this.id,
    required this.keyword,
  });
}
