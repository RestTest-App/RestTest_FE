class TestInfoState{
  final int year;
  final int month;
  final String name;
  final int question_count;
  final int time;
  final int exam_attempt;
  final double pass_rate;

  TestInfoState({
    required this.year,
    required this.month,
    required this.name,
    required this.question_count,
    required this.time,
    required this.exam_attempt,
    required this.pass_rate,
  });

  factory TestInfoState.empty() {
    return TestInfoState(
      year: 0,
      month: 0,
      name: '',
      question_count: 0,
      time: 0,
      exam_attempt: 0,
      pass_rate: 0.0,
    );
  }

  factory TestInfoState.fromJson(Map<String, dynamic> json) {
    return TestInfoState(
      year: json['year'],
      month: json['month'],
      name: json['name'],
      question_count: json['question_count'],
      time: json['time'],
      exam_attempt: json['exam_attempt'],
      pass_rate: (json['pass_rate'] as num).toDouble(), // double 변환 주의
    );
  }
}