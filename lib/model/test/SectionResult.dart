class SectionResult {
  final String name;
  final int correctCount;
  final int totalCount;
  final int score;

  SectionResult({
    required this.name,
    required this.correctCount,
    required this.totalCount,
    required this.score,
  });

  factory SectionResult.fromJson(Map<String, dynamic> json) {
    return SectionResult(
      name: json['section_name'],
      correctCount: json['correct_count'],
      totalCount: json['total_count'],
      score: json['score'],
    );
  }
}
