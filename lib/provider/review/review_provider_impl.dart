import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/provider/review/review_provider.dart';

class ReviewProviderImpl extends BaseConnect implements ReviewProvider {
  @override
  Future<List<dynamic>> fetchReviewList({int? category}) async {
    try {
      String url = '/api/v1/review/get-review-note-list';
      if (category != null) {
        url += '?category=$category';
      }

      print('🔍 [ReviewProvider] fetchReviewList 요청 URL: $url');
      final response = await get(url);
      print(
          '🔍 [ReviewProvider] fetchReviewList 응답 상태: ${response.statusCode}');
      print('🔍 [ReviewProvider] fetchReviewList 응답 전체: ${response.body}');

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['data'] != null) {
        // 백엔드 응답 구조에 맞춰서 exams 배열 반환
        final data = response.body['data'];
        print('🔍 [ReviewProvider] data 구조: $data');

        if (data['exams'] != null) {
          print('🔍 [ReviewProvider] exams 배열 길이: ${data['exams'].length}');
          return data['exams'];
        } else {
          print('🔍 [ReviewProvider] exams가 null입니다.');
          return []; // exams가 없으면 빈 배열 반환
        }
      } else {
        print('❌ [ReviewProvider] 잘못된 응답: ${response.body}');
        throw Exception("Invalid response: ${response.body}");
      }
    } catch (e) {
      print('❌ [ReviewProvider] fetchReviewList 에러: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchReviewDetail(int reviewId) async {
    try {
      print('🔍 [ReviewProvider] fetchReviewDetail 요청 reviewId: $reviewId');
      final response =
          await get('/api/v1/review/get-review-note-test-mode/$reviewId');

      print(
          '🔍 [ReviewProvider] fetchReviewDetail 응답 상태: ${response.statusCode}');
      print('🔍 [ReviewProvider] fetchReviewDetail 응답 전체: ${response.body}');

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['data'] != null) {
        final data = response.body['data'];
        print('🔍 [ReviewProvider] data 구조: $data');

        // questions 필드 확인
        if (data['questions'] != null) {
          print(
              '🔍 [ReviewProvider] questions 배열 길이: ${data['questions'].length}');
          print('🔍 [ReviewProvider] questions 내용: ${data['questions']}');
        } else {
          print('❌ [ReviewProvider] questions가 null입니다!');
        }

        // exam 필드 확인
        if (data['exam'] != null) {
          print('🔍 [ReviewProvider] exam 정보: ${data['exam']}');
        } else {
          print('❌ [ReviewProvider] exam이 null입니다!');
        }

        return data;
      } else {
        print('❌ [ReviewProvider] 잘못된 응답: ${response.body}');
        throw Exception("Invalid response: ${response.body}");
      }
    } catch (e) {
      print('❌ [ReviewProvider] fetchReviewDetail 에러: $e');
      rethrow;
    }
  }
}
