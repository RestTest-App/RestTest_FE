abstract class ReviewProvider {
  Future<List<dynamic>> fetchReviewList();
  Future<Map<String, dynamic>> fetchReviewDetail(int reviewId);
}
