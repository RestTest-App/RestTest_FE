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
      // API 호출 실패 시 기존 데이터를 유지 (clear하지 않음)
      // _allReviews.clear();
      // _filteredReviews.clear()
      print('⚠️ [ReviewViewModel] API 호출 실패 - 기존 데이터 유지');
      // 에러를 다시 던져서 상위에서 처리할 수 있도록 함
      rethrow;
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
    print('🔍 [ReviewViewModel] selectCategory 호출 - category: $category');
    _selectedCategory.value = category;
    _applyFilter();
  }

  // 카테고리를 백엔드 API용 숫자로 변환
  int? _getCategoryId(String category) {
    print('🔍 [ReviewViewModel] _getCategoryId 호출 - category: $category');
    int? categoryId;
    switch (category) {
      case '정보처리기사':
        categoryId = 1;
        break;
      case '한국사능력검정시험':
        categoryId = 2;
        break;
      case '컴퓨터활용능력1급':
        categoryId = 3;
        break;
      // ... 기타 자격증 매핑 필요시 추가
      case '전체':
      default:
        categoryId = null;
        break;
    }
    print('🔍 [ReviewViewModel] _getCategoryId 결과 - categoryId: $categoryId');
    return categoryId;
  }

  // 카테고리별 복습노트 로드
  Future<void> loadReviewListByCategory(String category) async {
    print(
        '🔍 [ReviewViewModel] loadReviewListByCategory 호출 - category: $category');
    final categoryId = _getCategoryId(category);
    print('🔍 [ReviewViewModel] API 호출할 categoryId: $categoryId');

    try {
      await loadReviewList(category: categoryId); // 전체면 null이 들어감
      print('🔍 [ReviewViewModel] 카테고리별 API 호출 성공');
    } catch (e) {
      print('⚠️ [ReviewViewModel] 카테고리별 API 호출 실패: $e');
      print('⚠️ [ReviewViewModel] 전체 목록에서 필터링으로 대체');

      // 카테고리별 API 호출이 실패하면 전체 목록을 다시 로드하고 프론트엔드에서 필터링
      try {
        await loadReviewList(category: null); // 전체 목록 로드
        print('🔍 [ReviewViewModel] 전체 목록 로드 성공 - 프론트엔드 필터링 적용');
      } catch (e2) {
        print('❌ [ReviewViewModel] 전체 목록 로드도 실패: $e2');
        // 전체 목록도 실패하면 기존 데이터로 필터링
        print('⚠️ [ReviewViewModel] 기존 데이터로 프론트엔드 필터링 적용');
        _applyFilter();
      }

      // 사용자 알림 제거 - 조용히 처리
    }
  }

  void _applyFilter() {
    print(
        '🔍 [ReviewViewModel] _applyFilter 호출 - selectedCategory: ${_selectedCategory.value}');
    print('🔍 [ReviewViewModel] _allReviews 길이: ${_allReviews.length}');

    if (_selectedCategory.value == '전체') {
      _filteredReviews.value = _allReviews;
      print(
          '🔍 [ReviewViewModel] 전체 선택 - filteredReviews 길이: ${_filteredReviews.length}');
    } else {
      // 백엔드에서 카테고리 필터링이 안 될 경우를 대비해 프론트엔드에서 강화된 필터링
      final filtered = _allReviews.where((exam) {
        final matches = exam.certificate == _selectedCategory.value;
        print(
            '🔍 [ReviewViewModel] exam.certificate: "${exam.certificate}" vs selectedCategory: "${_selectedCategory.value}" -> $matches');
        return matches;
      }).toList();

      _filteredReviews.value = filtered;
      print(
          '🔍 [ReviewViewModel] 카테고리 필터링 - filteredReviews 길이: ${_filteredReviews.length}');
      print(
          '🔍 [ReviewViewModel] 필터링 조건: exam.certificate == "${_selectedCategory.value}"');

      // 디버깅: 각 exam의 certificate 확인
      for (int i = 0; i < _allReviews.length; i++) {
        print(
            '🔍 [ReviewViewModel] exam[$i].certificate: "${_allReviews[i].certificate}"');
      }

      // 필터링 결과가 0개인 경우 경고
      if (filtered.isEmpty) {
        print('⚠️ [ReviewViewModel] 경고: 필터링 결과가 0개입니다!');
        print('⚠️ [ReviewViewModel] 선택된 카테고리: "${_selectedCategory.value}"');
        print('⚠️ [ReviewViewModel] 사용 가능한 certificate들:');
        final uniqueCertificates =
            _allReviews.map((e) => e.certificate).toSet();
        for (final cert in uniqueCertificates) {
          print('⚠️ [ReviewViewModel] - "$cert"');
        }
      }
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
