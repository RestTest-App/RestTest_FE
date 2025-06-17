import 'package:rest_test/model/test/SectionResult.dart';
import 'package:rest_test/model/test/TestResult.dart';

class TestSubmitResponse {
  final TestResult testLog;
  final List<int> correctAnswers;
  final List<AnswerExplanation> correctAnswerInfo;
  final List<SectionResult> section_info;

  TestSubmitResponse({
    required this.testLog,
    required this.correctAnswers,
    required this.correctAnswerInfo,
    required this.section_info,
  });

  factory TestSubmitResponse.fromJson(Map<String, dynamic> data) {
    return TestSubmitResponse(
      testLog: TestResult.fromJson(data['test_log']),
      correctAnswers: List<int>.from(data['correct_answer']),
      correctAnswerInfo: List<AnswerExplanation>.from(
        data['correct_answer_info'].asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          return AnswerExplanation.fromJson(value, index);
        }),
      ),
      section_info: List<SectionResult>.from(
        data['section_info'].map((json) => SectionResult.fromJson(json)),
      ),
    );
  }

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

  factory AnswerExplanation.fromJson(Map<String, dynamic> json, int index) {
    return AnswerExplanation(
      answer: json['answer'],
      description: "문제 ${index + 1}", // 혹은 필요하면 문제 설명 따로 전달받아야 할 수도 있음
      optionExplanations: OptionExplanations.fromJson(json['option_explanations']),
    );
  }
}


// 번호별 해설
class OptionExplanations {
  final Map<String, String> options;

  OptionExplanations({required this.options});

  factory OptionExplanations.fromJson(Map<String, dynamic> json) {
    return OptionExplanations(
      options: Map<String, String>.from(json),
    );
  }

  String? explanationFor(String key) {
    return options[key]; // 예: "no3"
  }
}
