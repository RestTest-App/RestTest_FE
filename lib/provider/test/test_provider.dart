import '../../model/test/ReportRequest.dart';

abstract class TestProvider{
  Future<dynamic> readTestInfo(int examId);
  Future<List<dynamic>> readQuestionList(int examId);
  Future<Map<String, dynamic>> sendTestResult(int examId, List<int> answers);
  Future<void> sendExplanationReport(ReportRequest request);
}