class Exam {
  final int examId;
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
      examId: json['id'],
      examName: json['name'] ?? '',
      questionCount: json['question_count'], // 실제 응답에 없음. 필요 시 서버에서 추가 or 임시 0
      examTime: json['time'] ?? 0,
      passRate: (json['pass_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

}
