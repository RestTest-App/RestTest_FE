import 'package:rest_test/model/review/ReviewListModel.dart';
import 'package:rest_test/model/review/ReviewDetailModel.dart';

abstract class ReviewProvider {
  Future<List<dynamic>> fetchReviewList({int? category});
  Future<Map<String, dynamic>> fetchReviewDetail(int reviewId);
}
