class LegalTip {
  final int id;
  final String category;
  final String title;
  final String content;
  final List<String> tags;

  const LegalTip({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    this.tags = const [],
  });

  bool get hasLongContent => content.length > 220;
}
