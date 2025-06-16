import 'package:rest_test/model/test/Question.dart';
import 'package:rest_test/model/test/TestInfoState.dart';
import '../../model/test/ReportRequest.dart';
import '../../model/test/TestSubmitResponse.dart';

abstract class TestRepository {
  Future<TestInfoState> readTestInfo(int examId);
  Future<List<Question>> readQuestionList(int examId);
  Future<TestSubmitResponse> sendTestResult(int examId, List<int> answers);
  Future<void> sendExplanationReport(ReportRequest request);
}