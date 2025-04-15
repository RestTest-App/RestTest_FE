import 'package:get/get.dart';
import 'package:rest_test/model/test/TestInfoState.dart';

class TestViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  final Rx<TestInfoState> _state = TestInfoState.empty().obs;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */

  TestInfoState get state => _state.value;
  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  @override
  void onInit() {
    super.onInit();
    _loadTestInfo();
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

}