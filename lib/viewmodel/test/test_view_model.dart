import 'package:get/get.dart';
import 'package:rest_test/model/test/Question.dart';
import 'package:rest_test/model/test/TestInfoState.dart';

class TestViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // text Info
  final Rx<TestInfoState> _state = TestInfoState.empty().obs;

  // test Exam
  // 변수 : 문제리스트, 페이지컨트롤러, 선택한 문제, 현재 문제 번호
  // 전체 문제 리스트
  final RxList<Question> _questions = <Question>[].obs;
  // 현재 보고 있는 문제 인덱스
  final RxInt _currentIndex = 0.obs;
  // 각 문제에 대한 선택된 보기 인덱스를 저장 (index: 선택한 보기 번호)
  final RxList<int?> _selectedOptions = <int?>[].obs;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  TestInfoState get state => _state.value;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex.value;
  Question get currentQuestion => _questions[_currentIndex.value];
  int? get selectedOption => _selectedOptions[_currentIndex.value];
  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  @override
  void onInit() {
    super.onInit();
    _loadTestInfo();
    _loadQuestions();
  }

  void _loadTestInfo() {
    _state.value = TestInfoState(
      year: 2024,
      month: 7,
      name: "2024년 3회 정보처리기사",
      question_count: 10,
      time: 80,
      exam_attempt: 1,
      pass_rate: 55.79
    );
  }

  void _loadQuestions() {
    final data = [
      Question(answer_rate: 89.23, seciton: "1과목", description: "다음 중 수의 표현에 있어 진법에 대한 설명으로 옳지 않은 것은?", options: [
        "16진수(Hexadecimal)는 0~9까지의 숫자와 A~F까지 문자로 표현하는 진법으로 한 자리수를 표현하는데 4개의 비트가 필요하다",
        "16진수(Hexadecimal)는 0~9까지의 숫자와 A~F까지 문자로 표현하는 진법으로 한 자리수를 표현하는데 4개의 비트가 필요하다",
        "16진수(Hexadecimal)는 0~9까지의 숫자와 A~F까지 문자로 표현하는 진법으로 한 자리수를 표현하는데 4개의 비트가 필요하다",
        "16진수(Hexadecimal)는 0~9까지의 숫자와 A~F까지 문자로 표현하는 진법으로 한 자리수를 표현하는데 4개의 비트가 필요하다",
      ]),
      Question(answer_rate: 95.33, seciton: "석기시대", description: "(가) 시대에 대한 탐구 활동으로 가장 적절한 것은?", description_image: "assets/images/exampleQ.png", options: [
        "주먹도끼의 용도를 알아본다.",
        "철제 갑옷의 제작 기법을 살펴본다.",
        "금관이 출토된 고분에 대해 조사한다.",
        "비파형 동검의 형태적 특징을 분석한다.",
        "어쩌구 저쩌구 솔라솰라",
      ]),
      Question(answer_rate: 50.25, seciton: "2과목", description: "TCP 프로토콜과 관련한 설명으로 틀린 것은?", options: [
        "인접한 노드 사이의 프레임 전송 및 오류를 제어한다.",
        "흐름 제어(Flow Control)의 기능을 수행한다.",
        "전이중(Full Duplex) 방식의 양방향 가상회선을 제공한다.",
        "전송 데이터와 응답 데이터를 함께 전송할 수 있다.",
      ]),

    ];

    _questions.assignAll(data);
    _selectedOptions.assignAll(List<int?>.filled(data.length, null)); // 초기값 null
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

}