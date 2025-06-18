import 'package:rest_test/model/review/ReviewListModel.dart';
import 'package:rest_test/model/review/ReviewDetailModel.dart';

abstract class ReviewRepository {
  Future<List<ReviewListModel>> fetchReviewList();
  Future<ReviewDetailModel> fetchReviewDetail(int reviewId);
}
