import 'package:rest_test/provider/review/review_provider.dart';
import 'package:rest_test/repository/review/review_repository.dart';
import 'package:rest_test/model/review/ReviewListModel.dart';
import 'package:rest_test/model/review/ReviewDetailModel.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewProvider _reviewProvider;

  ReviewRepositoryImpl(this._reviewProvider);

  @override
  Future<List<ReviewListModel>> fetchReviewList({int? category}) async {
    print('🔍 [ReviewRepository] fetchReviewList 시작 - category: $category');

    final List<dynamic> data =
        await _reviewProvider.fetchReviewList(category: category);
    print('🔍 [ReviewRepository] Provider에서 받은 data 길이: ${data.length}');

    final result = data.map((e) => ReviewListModel.fromJson(e)).toList();
    print('🔍 [ReviewRepository] ReviewListModel 변환 완료 - ${result.length}개');

    return result;
  }

  @override
  Future<ReviewDetailModel> fetchReviewDetail(int reviewId) async {
    print('🔍 [ReviewRepository] fetchReviewDetail 시작 - reviewId: $reviewId');

    final Map<String, dynamic> data =
        await _reviewProvider.fetchReviewDetail(reviewId);
    print('🔍 [ReviewRepository] Provider에서 받은 data: $data');

    final result = ReviewDetailModel.fromJson(data);
    print('🔍 [ReviewRepository] ReviewDetailModel 변환 완료');
    print('🔍 [ReviewRepository] 최종 questions 길이: ${result.questions.length}');

    return result;
  }
}
