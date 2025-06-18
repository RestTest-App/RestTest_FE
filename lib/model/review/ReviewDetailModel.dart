class ReviewDetailModel {
  final int reviewNoteId;
  final DateTime createdAt;
  final ExamInfomation exam;
  final List<QuestionInfomation> questions;

  ReviewDetailModel({
    required this.reviewNoteId,
    required this.createdAt,
    required this.exam,
    required this.questions,
  });

  factory ReviewDetailModel.fromJson(Map<String, dynamic> json) {
    return ReviewDetailModel(
      reviewNoteId: json['review_note_id'],
      createdAt: DateTime.parse(json['created_at']),
      exam: ExamInfomation.fromJson(json['exam']),
      questions: (json['questions'] as List)
          .map((e) => QuestionInfomation.fromJson(e))
          .toList(),
    );
  }
}

class ExamInfomation {
  final int examId;
  final String name;
  final int year;
  final int month;
  final int trial;
  final int time;
  final double passRate;
  final int score;
  final bool isPassed;
  final DateTime solvedAt;

  ExamInfomation({
    required this.examId,
    required this.name,
    required this.year,
    required this.month,
    required this.trial,
    required this.time,
    required this.passRate,
    required this.score,
    required this.isPassed,
    required this.solvedAt,
  });

  factory ExamInfomation.fromJson(Map<String, dynamic> json) {
    return ExamInfomation(
      examId: json['exam_id'],
      name: json['name'],
      year: json['year'],
      month: json['month'],
      trial: json['trial'],
      time: json['time'],
      passRate: (json['pass_rate'] as num).toDouble(),
      score: json['score'],
      isPassed: json['is_passed'],
      solvedAt: DateTime.parse(json['solved_at']),
    );
  }
}

class QuestionInfomation {
  final int questionId;
  final double answerRate;
  final String section;
  final String description;
  final String? descriptionDetail;
  final String? descriptionImage;
  final List<String> options;
  final List<String> optionExplanations;
  final int answer;
  final int? selectedAnswer;
  final bool isCorrect;

  QuestionInfomation({
    required this.questionId,
    required this.answerRate,
    required this.section,
    required this.description,
    this.descriptionDetail,
    this.descriptionImage,
    required this.options,
    required this.optionExplanations,
    required this.answer,
    this.selectedAnswer,
    required this.isCorrect,
  });

  factory QuestionInfomation.fromJson(Map<String, dynamic> json) {
    return QuestionInfomation(
      questionId: json['question_id'],
      answerRate: (json['answer_rate'] as num).toDouble(),
      section: json['section'],
      description: json['description'],
      descriptionDetail: json['description_detail'],
      descriptionImage: json['description_image'],
      options: List<String>.from(json['options']),
      optionExplanations: List<String>.from(json['option_explanations']),
      answer: json['answer'],
      selectedAnswer: json['selected_answer'],
      isCorrect: json['is_correct'],
    );
  }
}
