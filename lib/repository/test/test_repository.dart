import 'package:rest_test/model/test/Question.dart';
import 'package:rest_test/model/test/TestInfoState.dart';
import 'package:rest_test/model/test/ReportRequest.dart';
import 'package:rest_test/model/test/TestSubmitResponse.dart';
import 'package:rest_test/model/home/exam_model.dart';
import 'package:rest_test/model/review/ReviewListModel.dart';

abstract class TestRepository {
  Future<TestInfoState> readTestInfo(int examId);
  Future<List<Question>> readQuestionList(int examId);
  Future<TestSubmitResponse> sendTestResult(int examId, List<int> answers);
  Future<void> sendExplanationReport(ReportRequest request);
  Future<List<Exam>> fetchExamListByType(int certificateId);
  Future<bool> addToReviewNote(List<int> questionIds);
}
