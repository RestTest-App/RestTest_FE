class ReportRequest {
  final String testId;
  final String questionId;
  final List<String> aiExplanation;
  final String feedback;


  ReportRequest({
      required this.testId,
      required this.questionId,
      required this.aiExplanation,
      required this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      "test_id": testId,
      "question_id": questionId,
      "ai_explanation": aiExplanation,
      "feedback": feedback,
    };
  }

}