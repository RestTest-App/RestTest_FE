import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/provider/test/test_provider.dart';

import '../../model/test/ReportRequest.dart';
import '../../utility/function/log_util.dart';

class TestProviderImpl extends BaseConnect implements TestProvider{
  @override
  Future<Map<String, dynamic>> readTestInfo(int examId) async {
    try {
      final response = await get('/api/v1/test/exam/$examId/info');

      if (response.statusCode == 200 && response.body != null && response.body['data'] != null) {
        return response.body['data'];
      } else {
        throw Exception("Invalid response: ${response.body}");
      }
    } catch (e) {
      print('readTestInfo error: $e');
      rethrow;
    }
  }

  @override
  Future<List> readQuestionList(int examId) async{
    try {
      final response = await get('/api/v1/test/test-mode/$examId');

      if (response.statusCode == 200 && response.body != null && response.body['data'] != null) {
        return response.body['data']['questions'];
      } else {
        throw Exception("Invalid response: ${response.body}");
      }
    } catch (e) {
      print('readTestInfo error: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> sendTestResult(int examId, List<int> answers) async {
    try {
      LogUtil.debug(answers);
      final response = await post(
        '/api/v1/test/submit-test/$examId',
        {
          "answers": answers,
        },
      );

      if (response.statusCode == 200 && response.body != null && response.body['data'] != null) {
        return response.body;
      } else {
        throw Exception("Invalid response: ${response.body}");
      }
    } catch (e) {
      print('sendTestResult error: $e');
      rethrow;
    }
  }

  @override
  Future<void> sendExplanationReport(ReportRequest request) async {
    try {
      final response = await post(
        '/api/v1/test/send-answer-feedback',
        request.toJson(),
      );

      if (response.statusCode == 200) {
        LogUtil.debug("신고 전송 성공");
      } else {
        throw Exception("신고 전송 실패: ${response.body}");
      }
    } catch (e) {
      print('sendExplanationReport error: $e');
      rethrow;
    }
  }

}