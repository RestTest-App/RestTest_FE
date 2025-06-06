import 'package:get/get.dart';
import 'package:rest_test/model/home/exam_model.dart';

class HomeViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // 예: late final SomeRepository _someRepository;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  // 쉬엄 모드 / 시험 모드 (true = 쉬엄모드)
  final RxBool _isRestMode = true.obs;

  // 학습 문제 수
  final RxInt _questionCount = 5.obs;

  // 예시 시험 목록
  final RxList<Exam> _mockExams = <Exam>[].obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  // UI에서 사용하기 위해 getter 제공
  RxBool get isRestMode => _isRestMode;
  RxInt get questionCount => _questionCount;
  RxList<Exam> get mockExams => _mockExams;

  @override
  void onInit() {
    super.onInit();
    // 예: _someRepository = Get.find<SomeRepository>();
    _initExams();
  }

  /* ------------------------------------------------------ */
  /* ------------------- Methods -------------------------- */
  /* ------------------------------------------------------ */

  // 쉬엄 모드 / 시험 모드 토글
  void toggleMode(bool value) {
    _isRestMode.value = value;
  }

  // 문제 수 감소
  void decrementQuestionCount() {
    if (_questionCount.value > 5) {
      _questionCount.value -= 5;
    }
  }

  // 문제 수 증가
  void incrementQuestionCount() {
    if (_questionCount.value < 20) {
      _questionCount.value += 5;
    }
  }

  // 예시 시험 목록 초기화
  void _initExams() {
    _mockExams.addAll([
      Exam(
        examId: '9309281038',
        examName: '2024년 3회 정보처리기사',
        questionCount: 50,
        examTime: 80,
        passRate: 55.79,
      ),
      Exam(
        examId: '92774282362',
        examName: '2024년 2회 정보처리기사',
        questionCount: 50,
        examTime: 80,
        passRate: 62.82,
      ),
    ]);
  }
}
