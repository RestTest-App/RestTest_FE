import 'package:get/get.dart';
import 'package:rest_test/model/test/Question.dart';
import 'package:rest_test/model/test/TestInfoState.dart';
import 'package:rest_test/provider/test/test_provider.dart';
import 'package:rest_test/repository/test/test_repository.dart';
import 'package:rest_test/model/home/exam_model.dart';
import 'package:rest_test/model/test/ReportRequest.dart';
import 'package:rest_test/model/test/TestSubmitResponse.dart';

class TestRepositoryImpl extends GetxService implements TestRepository {
  late final TestProvider _testProvider;

  @override
  void onInit() {
    super.onInit();
    _testProvider = Get.find<TestProvider>();
  }

  @override
  Future<TestInfoState> readTestInfo(int examId) async {
    final Map<String, dynamic> data = await _testProvider.readTestInfo(examId);
    return TestInfoState.fromJson(data);
  }

  @override
  Future<List<Question>> readQuestionList(int examId) async {
    List<dynamic> data = await _testProvider.readQuestionList(examId);
    return List<Question>.from(data.map((q) => Question.fromJson(q)));
  }

  @override
  Future<TestSubmitResponse> sendTestResult(
      int examId, List<int> answers) async {
    final response = await _testProvider.sendTestResult(examId, answers);
    final data = response['data'];

    if (data == null) {
      throw Exception("응답에 data가 없습니다: $response"); // 문제 디버깅도 쉽게
    }

    // 응답 JSON을 파싱하여 TestSubmitResponse로 변환
    return TestSubmitResponse.fromJson(data);
  }

  @override
  Future<void> sendExplanationReport(ReportRequest request) async {
    await _testProvider.sendExplanationReport(request);
  }

  @override
  Future<List<Exam>> fetchExamListByType(int certificateId) async {
    final List<dynamic> data =
        await _testProvider.fetchExamListByType(certificateId);
    return data.map((e) => Exam.fromJson(e)).toList();
  }

  @override
  Future<bool> addToReviewNote(int examId, List<int> questionIds) async {
    return await _testProvider.addToReviewNote(examId, questionIds);
  }

  @override
  Future<bool> addToReviewNoteWithResult(
      int examId, int resultId, List<int> questionIds) async {
    return await _testProvider.addToReviewNoteWithResult(
        examId, resultId, questionIds);
  }
}
