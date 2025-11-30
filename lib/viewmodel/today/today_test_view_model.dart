import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rest_test/repository/today/today_repository.dart';

import '../../model/today/TodayTestState.dart';
import '../root/root_view_model.dart';

class TodayTestViewModel extends GetxController {
  late final RootViewModel _rootViewModel;
  late final TodayRepository _todayRepository;

  final Rx<TodayTestState?> _todayTestState = Rx<TodayTestState?>(null);
  TodayTestState? get todayTestState => _todayTestState.value;

  // 전체 문제 리스트
  final RxList<TodayQuestion> _questions = <TodayQuestion>[].obs;
  // 현재 보고 있는 문제 인덱스
  final RxInt _currentIndex = 0.obs;
  // 각 문제에 대한 선택된 보기 인덱스를 저장 (index: 선택한 보기 번호)
  final RxList<int?> _selectedOptions = <int?>[].obs;

  int get currentIndex => _currentIndex.value;
  TodayQuestion get currentQuestion => _questions[_currentIndex.value];
  int? get selectedOption => _selectedOptions[_currentIndex.value];
  List<int?> get selectedOptions => _selectedOptions;
  bool get isLast => _currentIndex.value == _questions.length - 1;
  bool get allAnswered => !_selectedOptions.contains(null);
  bool get isLastQuestion => _currentIndex.value == _questions.length - 1;
  List<int> get correctAnswers => _questions.map((q) => q.answer).toList();

  bool get canSubmit => isLastQuestion && allAnswered;

  @override
  void onInit() {
    super.onInit();
    _rootViewModel = Get.find<RootViewModel>();
    _todayRepository = Get.find<TodayRepository>();
  }

  Future<void> createTodayTest(int certificateId) async {
    await _todayRepository.createTodayTest(certificateId);
  }

  Future<void> loadTodayTest() async {
    try {
      final result = await _todayRepository.getTodayTest();
      _todayTestState.value = result;

      _questions.assignAll(result.questions); // 문제 할당
      _selectedOptions
          .assignAll(List<int?>.filled(result.questions.length, null));
    } catch (e) {
      print("오늘의 문제 로딩 실패: $e");
    }
  }

  void selectOption(int index) {
    _selectedOptions[_currentIndex.value] = index;
    _selectedOptions.refresh();
  }

  void next() {
    if (_currentIndex.value < _questions.length - 1) {
      _currentIndex.value++;
    }
  }

  void prev() {
    if (_currentIndex.value > 0) {
      _currentIndex.value--;
    }
  }

  void goTo(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex.value = index;
    }
  }

  bool isAnswered(int index) {
    return _selectedOptions[index] != null;
  }

  Future<void> submitTodayTest() async {
    try {
      await _todayRepository.sendTodayTest();
      _currentIndex.value = 0;
      print("오늘의 문제 제출 완료");
    } catch (e) {
      print("제출 실패: $e");
    }
  }

  Future<void> resetExamState() async {
    try {
      _questions.clear();
      _selectedOptions.clear();
      _currentIndex.value = 0;
      correctAnswers.clear();

      await loadTodayTest();
    } catch (e) {
      print("resetExamState 실패: $e");
    }
  }
}
