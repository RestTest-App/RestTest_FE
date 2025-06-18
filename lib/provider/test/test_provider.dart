import 'package:rest_test/model/test/ReportRequest.dart';

abstract class TestProvider {
  Future<dynamic> readTestInfo(int examId);
  Future<List<dynamic>> readQuestionList(int examId);
  Future<Map<String, dynamic>> sendTestResult(int examId, List<int> answers);
  Future<void> sendExplanationReport(ReportRequest request);
  Future<List<dynamic>> fetchExamListByType(int certificateId);
  Future<bool> addToReviewNote(int examId, List<int> questionIds);
  Future<bool> addToReviewNoteWithResult(
      int examId, int resultId, List<int> questionIds);
}
