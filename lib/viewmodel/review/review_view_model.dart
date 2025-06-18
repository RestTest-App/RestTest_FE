import 'package:get/get.dart';
import 'package:rest_test/model/review/ReviewListModel.dart';
import 'package:rest_test/repository/review/review_repository.dart';

import '../../model/review/ReviewDetailModel.dart';

class ReviewViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final ReviewRepository _reviewRepository = Get.find();

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxString _selectedCategory = '전체'.obs;

  final RxList<ReviewListModel> _allReviews = <ReviewListModel>[].obs;

  final RxList<ReviewListModel> _filteredReviews = <ReviewListModel>[].obs;

  // 복습 디테일
  final Rx<ReviewDetailModel?> _reviewDetail = Rx<ReviewDetailModel?>(null);
  final RxInt _currentIndex = 0.obs;
  final Rxn<List<QuestionInfomation>> _questions =
      Rxn<List<QuestionInfomation>>();
  List<QuestionInfomation> get questions => _questions.value ?? [];
  // 각 문제의 정답 번호 (answer)
  List<int> get correctAnswers => questions.map((q) => q.answer).toList();

  // 각 문제의 사용자가 선택한 번호 (selectedAnswer)
  List<int?> get selectedOptions =>
      questions.map((q) => q.selectedAnswer).toList();

/* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  List<String> get categories => ['전체', '정보처리기사', '컴퓨터활용능력1급', '한국사능력검정시험'];

  String get selectedCategory => _selectedCategory.value;
  List<ReviewListModel> get filteredReviews => _filteredReviews;
  List<ReviewListModel> get allReviews => _allReviews;

  // 복습 디테일
  ReviewDetailModel? get reviewDetail => _reviewDetail.value;
  int get currentIndex => _currentIndex.value;

  QuestionInfomation? get currentQuestion {
    if (_currentIndex.value >= questions.length) return null;
    return questions[_currentIndex.value];
  }

  @override
  void onInit() {
    super.onInit();
    loadReviewList();
  }

  Future<void> loadReviewList() async {
    try {
      final reviews = await _reviewRepository.fetchReviewList();
      _allReviews.assignAll(reviews);
      _applyFilter();
    } catch (e) {
      print('복습노트 목록 로드 실패: $e');
      Get.snackbar('오류', '복습노트 목록을 불러오는데 실패했습니다.');
    }
  }

  void selectCategory(String category) {
    _selectedCategory.value = category;
    _applyFilter();
  }

  void _applyFilter() {
    if (_selectedCategory.value == '전체') {
      _filteredReviews.value = _allReviews;
    } else {
      _filteredReviews.value = _allReviews
          .where((exam) => exam.certificate == _selectedCategory.value)
          .toList();
    }
  }

  // 복습노트에 문제 추가 (이 부분은 필요하다면 TestRepository로 DI 추가)
  // Future<void> addToReviewNote(List<int> questionIds) async {
  //   final result = await _testRepository.addToReviewNote(questionIds);
  //   if (result) {
  //     Get.snackbar('성공', '복습노트에 추가되었습니다.');
  //   } else {
  //     Get.snackbar('실패', '복습노트 추가에 실패했습니다.');
  //   }
  // }

  // 다음 문제
  void nextQuestion() {
    if (_currentIndex.value < questions.length - 1) {
      _currentIndex.value++;
    }
  }

  // 이전 문제
  void prevQuestion() {
    if (_currentIndex.value > 0) {
      _currentIndex.value--;
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      _currentIndex.value = index;
    }
  }
}
