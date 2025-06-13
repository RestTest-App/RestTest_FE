import 'package:get/get.dart';
import 'package:rest_test/model/review/ReviewListModel.dart';

import '../../model/review/ReviewDetailModel.dart';

class ReviewViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  final RxString _selectedCategory = '전체'.obs;

  final RxList<ReviewListModel> _allReviews = <ReviewListModel>[].obs;

  final RxList<ReviewListModel> _filteredReviews = <ReviewListModel>[].obs;

  // 복습 디테일
  final Rx<ReviewDetailModel?> _reviewDetail = Rx<ReviewDetailModel?>(null);
  final RxInt _currentIndex = 0.obs;
  final Rxn<List<QuestionInfomation>> _questions = Rxn<List<QuestionInfomation>>();
  List<QuestionInfomation> get questions => _questions.value ?? [];
  // 각 문제의 정답 번호 (answer)
  List<int> get correctAnswers =>
      questions.map((q) => q.answer).toList();

  // 각 문제의 사용자가 선택한 번호 (selectedAnswer)
  List<int?> get selectedOptions =>
      questions.map((q) => q.selectedAnswer).toList();

/* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  List<String> get categories => ['전체', '정보처리기사', '컴퓨터활용능력1급','한국사능력검정시험'];

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
    _loadReviewsData();
    _applyFilter();
    loadDummyReviewDetailData();
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

  void _loadReviewsData() {
    _allReviews.addAll([
      ReviewListModel(review_note_id: "re220481hdheu",
          exam_id: "info2810853fd",
          name: "2023년 정보처리기사 제 1회",
          is_passed: true,
          certificate: "정보처리기사",
          read_count: 1,
          pass_rate: 45.55),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853ff", name: "2023년 정보처리기사 제 2회", is_passed: true, certificate: "정보처리기사", read_count: 3, pass_rate: 45.55),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853fx", name: "2022년 정보처리기사 제 3회", is_passed: false, certificate: "정보처리기사", read_count: 1, pass_rate: 45.55),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853fh", name: "2024년 한국사능력검정시험 7월", is_passed: true, certificate: "한국사능력검정시험", read_count: 2, pass_rate: 70),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853sx", name: "2023년 컴퓨터활용능1급 제 5회", is_passed: true, certificate: "컴퓨터활용능1급", read_count: 3, pass_rate: 58.56),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853sx", name: "2024년 컴퓨터활용능1급 제 3회", is_passed: false, certificate: "컴퓨터활용능1급", read_count: 2, pass_rate: 72.44),
      ReviewListModel(review_note_id: "re220481hdheu", exam_id: "info2810853sx", name: "2025년 컴퓨터활용능1급 제 1회", is_passed: true, certificate: "컴퓨터활용능1급", read_count: 1, pass_rate: 40.55)
    ]);
  }

  void loadDummyReviewDetailData() {
    _reviewDetail.value = ReviewDetailModel(
      reviewNoteId: 12345,
      createdAt: DateTime.parse("2025-03-30T11:05:00"),
      exam: ExamInfomation(
        examId: 999,
        name: "정보처리기사",
        year: 2024,
        month: 2,
        trial: 2,
        time: 80,
        passRate: 62.5,
        score: 73,
        isPassed: true,
        solvedAt: DateTime.parse("2025-03-28T10:00:00"),
      ),
      questions: [
        QuestionInfomation(
          questionId: 109,
          answerRate: 48.3,
          section: "1과목",
          description: "16진수에서 한 자릿수를 표현하는 데 필요한 비트 수는?",
          descriptionDetail: null,
          descriptionImage: "assets/images/exampleQ.png",
          options: ["주먹도끼의 용도를 알아본다.",
            "철제 갑옷의 제작 기법을 살펴본다.",
            "금관이 출토된 고분에 대해 조사한다.",
            "비파형 동검의 형태적 특징을 분석한다.",
            "어쩌구 저쩌구 솔라솰라",],
          optionExplanations: [
            "2비트로는 부족하다",
            "4비트가 맞다",
            "8비트는 과하다",
            "16비트는 너무 크다",
            "16비트는 너무 크다",
          ],
          answer: 2,
          selectedAnswer: 2,
          isCorrect: true,
        ),
        QuestionInfomation(
          questionId: 108,
          answerRate: 42.5,
          section: "1과목",
          description: "자료의 분류 기준 중 하나는?",
          descriptionDetail: null,
          descriptionImage: null,
          options: ["정확성", "경제성", "보안성", "신속성"],
          optionExplanations: [
            "정확성은 중요하지만 분류 기준은 아님",
            "경제성은 관리 기준에 해당",
            "보안성도 마찬가지",
            "정답은 신속성"
          ],
          answer: 4,
          selectedAnswer: 2,
          isCorrect: false,
        ),
        QuestionInfomation(
          questionId: 109,
          answerRate: 48.3,
          section: "1과목",
          description: "16진수에서 한 자릿수를 표현하는 데 필요한 비트 수는?",
          descriptionDetail: null,
          descriptionImage: null,
          options: ["2비트", "4비트", "8비트", "16비트"],
          optionExplanations: [
            "2비트로는 부족하다",
            "4비트가 맞다",
            "8비트는 과하다",
            "16비트는 너무 크다"
          ],
          answer: 2,
          selectedAnswer: 2,
          isCorrect: true,
        ),
        QuestionInfomation(
          questionId: 108,
          answerRate: 42.5,
          section: "1과목",
          description: "자료의 분류 기준 중 하나는?",
          descriptionDetail: null,
          descriptionImage: null,
          options: ["정확성", "경제성", "보안성", "신속성"],
          optionExplanations: [
            "정확성은 중요하지만 분류 기준은 아님",
            "경제성은 관리 기준에 해당",
            "보안성도 마찬가지",
            "정답은 신속성"
          ],
          answer: 4,
          selectedAnswer: 2,
          isCorrect: false,
        ),
      ],
    );

    _questions.value = _reviewDetail.value?.questions ?? [];
    _currentIndex.value = 0;
  }

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