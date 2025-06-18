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
    print('🔍 [ReviewDetailModel] fromJson 시작 - 전체 JSON: $json');

    // review_note_id 파싱
    final reviewNoteId = json['review_note_id']?.toString() ?? '0';
    print(
        '🔍 [ReviewDetailModel] review_note_id: $reviewNoteId (타입: ${reviewNoteId.runtimeType})');

    // created_at 파싱
    final createdAt =
        DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String());
    print('🔍 [ReviewDetailModel] created_at: $createdAt');

    // exam 파싱
    print('🔍 [ReviewDetailModel] exam JSON: ${json['exam']}');
    final exam = ExamInfomation.fromJson(json['exam'] ?? {});
    print('🔍 [ReviewDetailModel] exam 파싱 완료');

    // questions 파싱
    print('🔍 [ReviewDetailModel] questions JSON: ${json['questions']}');
    print(
        '🔍 [ReviewDetailModel] questions 타입: ${json['questions'].runtimeType}');

    List<QuestionInfomation> questions = [];
    if (json['questions'] != null) {
      if (json['questions'] is List) {
        final questionsList = json['questions'] as List;
        print(
            '🔍 [ReviewDetailModel] questions 배열 길이: ${questionsList.length}');

        for (int i = 0; i < questionsList.length; i++) {
          print(
              '🔍 [ReviewDetailModel] question[$i] 파싱 시작: ${questionsList[i]}');
          try {
            final question = QuestionInfomation.fromJson(questionsList[i]);
            questions.add(question);
            print('🔍 [ReviewDetailModel] question[$i] 파싱 성공');
          } catch (e) {
            print('❌ [ReviewDetailModel] question[$i] 파싱 실패: $e');
            print(
                '❌ [ReviewDetailModel] question[$i] 데이터: ${questionsList[i]}');
          }
        }
      } else {
        print(
            '❌ [ReviewDetailModel] questions가 List가 아닙니다: ${json['questions'].runtimeType}');
      }
    } else {
      print('❌ [ReviewDetailModel] questions가 null입니다!');
    }

    print('🔍 [ReviewDetailModel] 최종 questions 길이: ${questions.length}');

    return ReviewDetailModel(
      reviewNoteId: int.tryParse(reviewNoteId) ?? 0,
      createdAt: createdAt,
      exam: exam,
      questions: questions,
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
    print('🔍 [ExamInfomation] fromJson 시작: $json');

    final examId = json['exam_id']?.toString() ?? '0';
    final name = json['name']?.toString() ?? '';
    final year = json['year']?.toString() ?? '0';
    final month = json['month']?.toString() ?? '0';
    final trial = json['trial']?.toString() ?? '0';
    final time = json['time']?.toString() ?? '0';
    final passRate = (json['pass_rate'] as num?)?.toDouble() ?? 0.0;
    final score = json['score']?.toString() ?? '0';
    final isPassed = json['is_passed'] ?? false;
    final solvedAt = DateTime.tryParse(json['solved_at']?.toString() ?? '') ??
        DateTime.now();

    print(
        '🔍 [ExamInfomation] pass_rate 원본: ${json['pass_rate']} (타입: ${json['pass_rate'].runtimeType})');
    print('🔍 [ExamInfomation] pass_rate 변환: $passRate');
    print('🔍 [ExamInfomation] score: $score (타입: ${score.runtimeType})');

    return ExamInfomation(
      examId: int.tryParse(examId) ?? 0,
      name: name,
      year: int.tryParse(year) ?? 0,
      month: int.tryParse(month) ?? 0,
      trial: int.tryParse(trial) ?? 0,
      time: int.tryParse(time) ?? 0,
      passRate: passRate,
      score: int.tryParse(score) ?? 0,
      isPassed: isPassed,
      solvedAt: solvedAt,
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
    print('🔍 [QuestionInfomation] fromJson 시작: $json');

    final questionId = json['question_id']?.toString() ?? '0';
    final answerRate = (json['answer_rate'] as num?)?.toDouble() ?? 0.0;
    final section = json['section']?.toString() ?? '';
    final description = json['description']?.toString() ?? '';
    final descriptionDetail = json['description_detail']?.toString();
    final descriptionImage = json['description_image']?.toString();
    final options = List<String>.from(json['options'] ?? []);
    final optionExplanations =
        List<String>.from(json['option_explanations'] ?? []);
    final answer = json['answer']?.toString() ?? '0';
    final selectedAnswer = json['selected_answer']?.toString();
    final isCorrect = json['is_correct'] ?? false;

    print(
        '🔍 [QuestionInfomation] question_id: $questionId (타입: ${questionId.runtimeType})');
    print('🔍 [QuestionInfomation] answer_rate: $answerRate');
    print(
        '🔍 [QuestionInfomation] answer: $answer (타입: ${answer.runtimeType})');
    print(
        '🔍 [QuestionInfomation] selected_answer: $selectedAnswer (타입: ${selectedAnswer.runtimeType})');
    print(
        '🔍 [QuestionInfomation] is_correct: $isCorrect (타입: ${isCorrect.runtimeType})');

    return QuestionInfomation(
      questionId: int.tryParse(questionId) ?? 0,
      answerRate: answerRate,
      section: section,
      description: description,
      descriptionDetail: descriptionDetail,
      descriptionImage: descriptionImage,
      options: options,
      optionExplanations: optionExplanations,
      answer: int.tryParse(answer) ?? 0,
      selectedAnswer:
          selectedAnswer != null ? int.tryParse(selectedAnswer) : null,
      isCorrect: isCorrect,
    );
  }
}
