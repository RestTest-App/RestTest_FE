class Exam {
  final String examId;
  final String examName;
  final int questionCount;
  final int examTime;
  final double passRate;

  Exam({
    required this.examId,
    required this.examName,
    required this.questionCount,
    required this.examTime,
    required this.passRate,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      examId: json['exam_id'],
      examName: json['exam_name'],
      questionCount: json['question_count'],
      examTime: json['exam_time'],
      passRate: (json['pass_rate'] as num).toDouble(),
    );
  }
}
