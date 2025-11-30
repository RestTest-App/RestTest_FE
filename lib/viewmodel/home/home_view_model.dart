import 'package:get/get.dart';
import 'package:rest_test/model/home/exam_model.dart';
import 'package:rest_test/repository/user/user_repository.dart';
import 'package:rest_test/model/test/TestInfoState.dart';
import 'package:rest_test/repository/test/test_repository.dart';
import 'package:rest_test/repository/goal/goal_repository.dart';
import 'package:rest_test/model/goal/goal_progress.dart';

class HomeViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  late final UserRepository _userRepository = Get.find();
  late final TestRepository _testRepository = Get.find();
  late final GoalRepository _goalRepository = Get.find();

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  // 쉬엄 모드 / 시험 모드 (true = 쉬엄모드)
  final RxBool _isRestMode = true.obs;

  // 학습 문제 수
  final RxInt _questionCount = 5.obs;

  final RxString _nickname = ''.obs;
  final RxString selectedExamType = '정처기'.obs;
  final RxInt selectedExamTypeInt = 1.obs;

  Rx<TestInfoState> testInfo = TestInfoState.empty().obs;

  final RxList<Exam> _filteredExams = <Exam>[].obs;

  // Goal 관련 필드
  final Rx<GoalProgressResponse?> _goalProgressResponse =
      Rx<GoalProgressResponse?>(null);
  final RxBool _isLoadingGoals = false.obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  // UI에서 사용하기 위해 getter 제공
  RxBool get isRestMode => _isRestMode;
  RxInt get questionCount => _questionCount;
  RxString get nickname => _nickname;

  List<Exam> get filteredExams => _filteredExams;

  // Goal 관련 getter
  GoalProgressResponse? get goalProgressResponse => _goalProgressResponse.value;
  List<GoalProgress> get goals => _goalProgressResponse.value?.goals ?? [];
  GoalSummary? get goalSummary => _goalProgressResponse.value?.summary;
  bool get hasGoals => goals.isNotEmpty;
  bool get isLoadingGoals => _isLoadingGoals.value;

  @override
  void onInit() {
    super.onInit();
    ever(selectedExamType, _updateSelectedExamTypeInt); // 이 줄 추가
    loadUserInfo();
    loadExamList();
    loadAllGoalsProgress();
  }

  /* ------------------------------------------------------ */
  /* ------------------- Methods -------------------------- */
  /* ------------------------------------------------------ */

  void _updateSelectedExamTypeInt(String type) {
    switch (type) {
      case '정처기':
        selectedExamTypeInt.value = 1;
        break;
      case '컴활':
        selectedExamTypeInt.value = 2;
        break;
      case '한능검':
        selectedExamTypeInt.value = 3;
        break;
      default:
        selectedExamTypeInt.value = 0; // 예외 처리
    }
  }

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
    try {
      final userInfo = await _userRepository.fetchUserInfo();
      if (userInfo != null && userInfo['nickname'] != null) {
        final nickname = userInfo['nickname'] as String;
        if (nickname.isNotEmpty) {
          _nickname.value = nickname;
          print('✅ 사용자 닉네임 로드 성공: $nickname');
        } else {
          print('⚠️ 닉네임이 비어있습니다.');
        }
      } else {
        print('⚠️ 사용자 정보를 불러올 수 없습니다. (서버 오류 가능)');
      }
    } catch (e) {
      print('⚠️ 사용자 정보 로드 실패: $e');
    }
  }

  Future<void> loadTestInfo(int examId) async {
    testInfo.value = await _testRepository.readTestInfo(examId);
  }

  Future<void> loadExamList() async {
    try {
      final exams =
          await _testRepository.fetchExamListByType(selectedExamTypeInt.value);
      _filteredExams.assignAll(exams);
    } catch (e) {
      print('시험 목록 로드 실패: $e');
      Get.snackbar('오류', '시험 목록을 불러오는데 실패했습니다.');
    }
  }

  Future<void> loadAllGoalsProgress() async {
    try {
      _isLoadingGoals.value = true;
      final response = await _goalRepository.fetchAllGoalsProgress();
      _goalProgressResponse.value = response;
    } catch (e) {
      print('⚠️ 목표 진행도 로드 실패: $e');
      _goalProgressResponse.value = null;
    } finally {
      _isLoadingGoals.value = false;
    }
  }
}
