import 'SectionResult.dart';

class TestResult {
  final int testTrackerId;
  final bool isPassed;
  final DateTime solvedAt;
  final int correctCount;
  final int totalCount;
  final List<SectionResult> sections;

  TestResult({
    required this.testTrackerId,
    required this.isPassed,
    required this.solvedAt,
    required this.correctCount,
    required this.totalCount,
    required this.sections,
  });
}