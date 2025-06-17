// models/today_test_state.dart
class TodayTestState {
  final bool isSolved;
  final int questionCount;
  final List<TodayQuestion> questions;

  TodayTestState({
    required this.isSolved,
    required this.questionCount,
    required this.questions,
  });

  factory TodayTestState.fromJson(Map<String, dynamic> json) {
    return TodayTestState(
      isSolved: json['is_solved'],
      questionCount: json['question_count'],
      questions: List<TodayQuestion>.from(
        json['question'].map((q) => TodayQuestion.fromJson(q)),
      ),
    );
  }
}

class TodayQuestion {
  final int questionId;
  final String description;
  final String? descriptionDetail;
  final List<String> options;
  final int answer;
  final List<String> optionExplanations;

  TodayQuestion({
    required this.questionId,
    required this.description,
    this.descriptionDetail,
    required this.options,
    required this.answer,
    required this.optionExplanations,
  });

  factory TodayQuestion.fromJson(Map<String, dynamic> json) {
    return TodayQuestion(
      questionId: json['question_id'],
      description: json['description'],
      descriptionDetail: json['description_detail'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
      optionExplanations: List<String>.from(json['option_explanations']),
    );
  }
}
