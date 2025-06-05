import 'package:rest_test/model/test/TestResult.dart';

class TestSubmitResponse {
  final TestResult testLog;
  final List<int> correctAnswers;
  final List<AnswerExplanation> correctAnswerInfo;

  TestSubmitResponse({
    required this.testLog,
    required this.correctAnswers,
    required this.correctAnswerInfo,
  });
}

// 정답 info
class AnswerExplanation {
  final int answer;
  final String description;
  final OptionExplanations optionExplanations;

  AnswerExplanation({
    required this.answer,
    required this.description,
    required this.optionExplanations,
  });
}

// 번호별 해설
class OptionExplanations {
  final Map<String, String> options;

  OptionExplanations({required this.options});

  String? explanationFor(String key) {
    return options[key]; // 예: "no3"
  }
}