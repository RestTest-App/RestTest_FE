import 'package:get/get.dart';
import 'package:rest_test/model/test/Question.dart';
import 'package:rest_test/model/test/SectionResult.dart';
import 'package:rest_test/model/test/TestInfoState.dart';
import 'package:rest_test/utility/function/log_util.dart';

import '../../model/test/ReportRequest.dart';
import '../../model/test/TestSubmitResponse.dart';
import '../../repository/test/test_repository.dart';
import '../root/root_view_model.dart';

class TestViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final RootViewModel _rootViewModel;
  late final TestRepository _testRepository;

  // text Info
  late final Rx<TestInfoState> _testInfoState = TestInfoState.empty().obs;
  TestInfoState get testInfoState => _testInfoState.value;

  // test Exam
  // 변수 : 문제리스트, 페이지컨트롤러, 선택한 문제, 현재 문제 번호
  // 전체 문제 리스트
  final RxList<Question> _questions = <Question>[].obs;
  // 현재 보고 있는 문제 인덱스
  final RxInt _currentIndex = 0.obs;
  // 각 문제에 대한 선택된 보기 인덱스를 저장 (index: 선택한 보기 번호)
  final RxList<int?> _selectedOptions = <int?>[].obs;

  // 시험 결과
  final RxList<SectionResult> _sectionResults = <SectionResult>[].obs;
  final RxBool _isPassed = false.obs;
  final RxInt _totalScore = 0.obs;

  // 시험 해설
  final RxList<int> _correctAnswers = <int>[].obs;
  final RxList<AnswerExplanation> _answerExplanations = <AnswerExplanation>[].obs;

  // 신고
  final RxString selectedReportOption = "".obs;
  final RxString etcText = "".obs;


  List<int> get correctAnswers => _correctAnswers;
  List<AnswerExplanation> get answerExplanations => _answerExplanations;
  AnswerExplanation get currentExplanation => _answerExplanations[_currentIndex.value];
  int get correctAnswer => _correctAnswers[_currentIndex.value];

  // 복습노트 추가
  final RxMap<int, bool> starredQuestions = <int, bool>{}.obs;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex.value;
  Question get currentQuestion => _questions[_currentIndex.value];
  int? get selectedOption => _selectedOptions[_currentIndex.value];
  List<int?> get selectedOptions => _selectedOptions;

  bool get isLastQuestion => _currentIndex.value == _questions.length - 1;
  bool get allAnswered => !_selectedOptions.contains(null);

  bool get canSubmit => isLastQuestion && allAnswered;

  // 시험 결과
  List<SectionResult> get sectionResults => _sectionResults;
  bool get isPassed => _isPassed.value;
  int get totalScore => _totalScore.value;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  @override
  void onInit() {
    super.onInit();
    _rootViewModel = Get.find<RootViewModel>();
    _testRepository = Get.find<TestRepository>();
    loadTestInfo(1);
    // _loadQuestions();
  }

  Future<void> loadTestInfo(int examId) async {
    try {
      final info = await _testRepository.readTestInfo(examId);
      _testInfoState.value = info;
    } catch (e) {
      print("시험 데이터 로딩 실패: $e");
    }
  }

  Future<void> loadQuestions(int examId) async {
    try {
      final data = await _testRepository.readQuestionList(examId);
      _questions.assignAll(data);
      _selectedOptions.assignAll(List<int?>.filled(data.length, null));
    } catch (e) {
      print("문제 데이터 로딩 실패: $e");
    }
  }

  // 보기 선택
  void selectOption(int optionIndex) {
    _selectedOptions[_currentIndex.value] = optionIndex;
    _selectedOptions.refresh(); // RxList 수동 갱신 필요
  }

  // 다음 문제
  void nextQuestion() {
    if (_currentIndex.value < _questions.length - 1) {
      _currentIndex.value++;
    }
  }

  // 이전 문제
  void prevQuestion() {
    if (_currentIndex.value > 0) {
      _currentIndex.value--;
    }
  }

  // 문제 선택 팝업에서 직접 번호 선택했을 때
  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex.value = index;
    }
  }

  // 해당 문제를 풀었는지 확인
  bool isAnswered(int index) {
    return _selectedOptions[index] != null;
  }

  // 복습노트 추가
  void toggleStarForQuestion(int index) {
    starredQuestions[index] = !(starredQuestions[index] ?? false);
  }

  bool isStarred(int index) {
    return starredQuestions[index] ?? false;
  }

  Future<void> submitTest(int examId) async {
    try {
      // null인 항목이 없다고 가정. 만약 있을 경우 0 등으로 기본 처리 가능
      final answers = _selectedOptions.map((e) => (e ?? 0) + 1).toList();

      final TestSubmitResponse response = await _testRepository.sendTestResult(examId, answers);

      // 시험 결과 반영
      _correctAnswers.assignAll(response.correctAnswers);
      _answerExplanations.assignAll(response.correctAnswerInfo);
      _sectionResults.assignAll(response.section_info);
      _isPassed.value = response.testLog.isPassed;
      _totalScore.value = response.testLog.correctCount;
    } catch (e) {
      print("시험 제출 실패: $e");
    }
  }

  Future<void> resetExamState() async {
    _questions.clear();
    _selectedOptions.clear();
    _currentIndex.value = 0;
    _correctAnswers.clear();
    _answerExplanations.clear();
    starredQuestions.clear();
    _sectionResults.clear();
    _isPassed.value = false;
    _totalScore.value = 0;

    await loadQuestions(1); // ✅ 여기도 수정됨
  }

  Future<void> sendReport(int testId, int questionId) async {
    final feedbackText = selectedReportOption.value == "기타"
        ? etcText.value.trim()
        : selectedReportOption.value;

    final aiExplanation = currentExplanation.optionExplanations.options.entries.map(
          (entry) => entry.value,
    ).toList();

    final request = ReportRequest(
      testId: testId.toString(),
      questionId: questionId.toString(),
      aiExplanation: aiExplanation,
      feedback: feedbackText,
    );

    try {
      await _testRepository.sendExplanationReport(request);  // ← Map<String, dynamic>을 넘기도록 정의
      print("신고 완료");
    } catch (e) {
      print("신고 실패: $e");
    }
  }

  void resetReportOption() {
    selectedReportOption.value = "";
  }

  void onEtcTextChanged(String value) {
    etcText.value = value;
    if (value.trim().isNotEmpty) {
      selectedReportOption.value = "기타";
    }
  }
}