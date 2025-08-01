import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/provider/test/test_provider.dart';

import 'package:rest_test/model/test/ReportRequest.dart';
import 'package:rest_test/utility/function/log_util.dart';

class TestProviderImpl extends BaseConnect implements TestProvider {
  @override
  Future<Map<String, dynamic>> readTestInfo(int examId) async {
    try {
      final response = await get('/api/v1/test/exam/$examId/info');

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['data'] != null) {
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
  Future<List> readQuestionList(int examId) async {
    try {
      final response = await get('/api/v1/test/test-mode/$examId');

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['data'] != null) {
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
  Future<Map<String, dynamic>> sendTestResult(
      int examId, List<int> answers) async {
    try {
      LogUtil.debug(answers);
      final response = await post(
        '/api/v1/test/submit-test/$examId',
        {
          "answers": answers,
        },
      );

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['data'] != null) {
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
        throw Exception("신고 전송 실패: \\${response.body}");
      }
    } catch (e) {
      print('sendExplanationReport error: $e');
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> fetchExamListByType(int certificateId) async {
    try {
      final response = await get('/api/v1/test/list/$certificateId');
      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['data'] != null &&
          response.body['data']['exams'] != null) {
        return response.body['data']['exams'];
      } else {
        throw Exception("Invalid response: ${response.body}");
      }
    } catch (e) {
      print('fetchExamListByType error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> addToReviewNote(int examId, List<int> questionIds) async {
    try {
      final response =
          await post('/api/v1/review/add-review-note-test-mode/$examId', {
        'result_id': 1, // 임시 값 - 실제로는 시험 결과 ID가 필요
        'test_id': examId,
        'question_list': questionIds
            .map((questionId) => {
                  'test_tracker_id': 1, // 임시 값 - 실제로는 test_tracker_id가 필요
                  'question_id': questionId,
                })
            .toList(),
      });

      // 백엔드 응답 구조 확인
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("복습노트 추가 실패: ${response.body}");
      }
    } catch (e) {
      print('addToReviewNote error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> addToReviewNoteWithResult(
      int examId, int resultId, List<int> questionIds) async {
    try {
      final response =
          await post('/api/v1/review/add-review-note-test-mode/$examId', {
        'result_id': resultId,
        'test_id': examId,
        'question_list': questionIds
            .map((questionId) => {
                  'test_tracker_id': resultId, // resultId가 test_tracker_id와 동일
                  'question_id': questionId,
                })
            .toList(),
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("복습노트 추가 실패: ${response.body}");
      }
    } catch (e) {
      print('addToReviewNoteWithResult error: $e');
      rethrow;
    }
  }
}
