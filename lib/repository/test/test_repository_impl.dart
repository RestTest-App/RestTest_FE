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
    // 1. [핵심] 타입을 dynamic으로 받아서 컴파일 에러를 회피합니다.
    final dynamic responseData = await _testProvider.readQuestionList(examId);

    // 디버깅용 로그 (실제 뭐가 들어오는지 콘솔에서 확인 가능)
    print("데이터 타입: ${responseData.runtimeType}");

    List<dynamic> list = [];

    // 2. 데이터 타입에 따라 다르게 처리 (안전장치)
    if (responseData is Map<String, dynamic>) {
      // 아까 로그처럼 Map으로 온 경우 (pass_rate, questions가 섞여있음)
      list = responseData['questions'] ?? [];
    } else if (responseData is List) {
      // 혹시라도 Provider가 진짜 리스트만 꺼내서 줬을 경우
      list = responseData;
    } else {
      // 데이터가 이상하면 빈 리스트 반환
      print("데이터 형식이 올바르지 않습니다: $responseData");
      return [];
    }

    // 3. Question 객체로 변환
    return List<Question>.from(list.map((q) => Question.fromJson(q)));
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
