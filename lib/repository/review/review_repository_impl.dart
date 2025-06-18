import 'package:rest_test/provider/review/review_provider.dart';
import 'package:rest_test/repository/review/review_repository.dart';
import 'package:rest_test/model/review/ReviewListModel.dart';
import 'package:rest_test/model/review/ReviewDetailModel.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewProvider _reviewProvider;

  ReviewRepositoryImpl(this._reviewProvider);

  @override
  Future<List<ReviewListModel>> fetchReviewList() async {
    final List<dynamic> data = await _reviewProvider.fetchReviewList();
    return data.map((e) => ReviewListModel.fromJson(e)).toList();
  }

  @override
  Future<ReviewDetailModel> fetchReviewDetail(int reviewId) async {
    final Map<String, dynamic> data =
        await _reviewProvider.fetchReviewDetail(reviewId);
    return ReviewDetailModel.fromJson(data);
  }
}
