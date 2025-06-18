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

  Future<void> loadReviewList({int? category}) async {
    try {
      final reviews =
          await _reviewRepository.fetchReviewList(category: category);
      _allReviews.assignAll(reviews);
      _applyFilter();
    } catch (e) {
      print('복습노트 목록 로드 실패: $e');
      _allReviews.clear();
      _filteredReviews.clear();
      Get.snackbar('알림', '복습노트 목록을 불러올 수 없습니다. 잠시 후 다시 시도해주세요.');
    }
  }

  Future<void> loadReviewDetail(int reviewId) async {
    try {
      print('🔍 [ReviewViewModel] loadReviewDetail 시작 - reviewId: $reviewId');

      final detail = await _reviewRepository.fetchReviewDetail(reviewId);
      print('🔍 [ReviewViewModel] Repository에서 받은 detail: $detail');

      _reviewDetail.value = detail;
      print('🔍 [ReviewViewModel] _reviewDetail 설정 완료');

      _questions.value = detail.questions;
      print(
          '🔍 [ReviewViewModel] _questions 설정 완료 - 길이: ${detail.questions.length}');

      _currentIndex.value = 0;
      print('🔍 [ReviewViewModel] _currentIndex 초기화 완료');

      // 추가 디버깅: questions가 비어있으면 경고
      if (detail.questions.isEmpty) {
        print('⚠️ [ReviewViewModel] 경고: questions가 비어있습니다!');
        print('⚠️ [ReviewViewModel] detail 전체 구조: $detail');
        print('⚠️ [ReviewViewModel] review_note_id: ${detail.reviewNoteId}');
        print('⚠️ [ReviewViewModel] exam_id: ${detail.exam.examId}');
        Get.snackbar(
          '알림',
          '복습노트에 문제가 없습니다.\n백엔드에서 데이터를 확인 중입니다.',
          duration: const Duration(seconds: 3),
        );
      } else {
        print(
            '✅ [ReviewViewModel] questions 로드 성공 - ${detail.questions.length}개 문제');
      }
    } catch (e) {
      print('❌ [ReviewViewModel] 복습노트 상세 로드 실패: $e');
      Get.snackbar('오류', '복습노트 상세를 불러오는데 실패했습니다.');
    }
  }

  void selectCategory(String category) {
    _selectedCategory.value = category;
    _applyFilter();
  }

  // 카테고리를 백엔드 API용 숫자로 변환
  int? _getCategoryId(String category) {
    switch (category) {
      case '정보처리기사':
        return 1;
      case '컴활':
        return 2;
      case '한능검':
        return 3;
      // ... 기타 자격증 매핑 필요시 추가
      case '전체':
      default:
        return null;
    }
  }

  // 카테고리별 복습노트 로드
  Future<void> loadReviewListByCategory(String category) async {
    final categoryId = _getCategoryId(category);
    await loadReviewList(category: categoryId); // 전체면 null이 들어감
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
