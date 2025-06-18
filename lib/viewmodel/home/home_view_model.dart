import 'package:get/get.dart';
import 'package:rest_test/model/home/exam_model.dart';
import 'package:rest_test/repository/user/user_repository.dart';
import 'package:rest_test/model/test/TestInfoState.dart';
import 'package:rest_test/repository/test/test_repository.dart';

class HomeViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final UserRepository _userRepository = Get.find();
  late final TestRepository _testRepository = Get.find();

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  // 쉬엄 모드 / 시험 모드 (true = 쉬엄모드)
  final RxBool _isRestMode = true.obs;

  // 학습 문제 수
  final RxInt _questionCount = 5.obs;

  final RxString _nickname = ''.obs;
  final RxString selectedExamType = '정처기'.obs;

  Rx<TestInfoState> testInfo = TestInfoState.empty().obs;

  final RxList<Exam> _filteredExams = <Exam>[].obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  // UI에서 사용하기 위해 getter 제공
  RxBool get isRestMode => _isRestMode;
  RxInt get questionCount => _questionCount;
  RxString get nickname => _nickname;

  List<Exam> get filteredExams => _filteredExams;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
    loadExamList();
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

  Future<void> loadUserInfo() async {
    final userInfo = await _userRepository.fetchUserInfo();
    if (userInfo != null) {
      _nickname.value = userInfo['nickname'] ?? '';
    }
  }

  Future<void> loadTestInfo(int examId) async {
    testInfo.value = await _testRepository.readTestInfo(examId);
  }

  Future<void> loadExamList() async {
    try {
      final exams =
          await _testRepository.fetchExamListByType(selectedExamType.value);
      _filteredExams.assignAll(exams);
    } catch (e) {
      print('시험 목록 로드 실패: $e');
      Get.snackbar('오류', '시험 목록을 불러오는데 실패했습니다.');
    }
  }
}
