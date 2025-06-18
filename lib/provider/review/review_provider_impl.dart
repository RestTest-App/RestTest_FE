import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/provider/review/review_provider.dart';

class ReviewProviderImpl extends BaseConnect implements ReviewProvider {
  @override
  Future<List<dynamic>> fetchReviewList() async {
    try {
      final response = await get('/api/v1/review/get-review-note-list');
      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['data'] != null) {
        return response.body['data'];
      } else {
        throw Exception("Invalid response: ${response.body}");
      }
    } catch (e) {
      print('fetchReviewList error: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchReviewDetail(int reviewId) async {
    try {
      final response =
          await get('/api/v1/review/get-review-note-test-mode/$reviewId');
      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['data'] != null) {
        return response.body['data'];
      } else {
        throw Exception("Invalid response: ${response.body}");
      }
    } catch (e) {
      print('fetchReviewDetail error: $e');
      rethrow;
    }
  }
}
