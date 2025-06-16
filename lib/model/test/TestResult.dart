
class TestResult {
  final int testTrackerId;
  final bool isPassed;
  final DateTime solvedAt;
  final int correctCount;
  final int totalCount;

  TestResult({
    required this.testTrackerId,
    required this.isPassed,
    required this.solvedAt,
    required this.correctCount,
    required this.totalCount,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      testTrackerId: json['test_tracker_id'],
      isPassed: json['is_passed'],
      solvedAt: DateTime.parse(json['solved_at']),
      correctCount: json['correct_count'],
      totalCount: json['total_count'],
    );
  }
}
