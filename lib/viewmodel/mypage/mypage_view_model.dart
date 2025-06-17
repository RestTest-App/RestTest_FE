import 'package:get/get.dart';
import 'package:rest_test/repository/user/user_repository.dart';

class MyPageViewModel extends GetxController {
  late final UserRepository _userRepository = Get.find();

  var nickname = ''.obs;
  var profileImageUrl = ''.obs;
  var currentYear = DateTime.now().year.obs;
  var currentMonth = DateTime.now().month.obs;

  var calendarDates = <DateTime>[].obs;
  var monthlyStudyDate = <int>[].obs;
  var attendanceCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
    loadStudyDates();
    generateCalendar(currentYear.value, currentMonth.value);
  }

  Future<void> loadUserInfo() async {
    final userInfo = await _userRepository.fetchUserInfo();
    if (userInfo != null) {
      nickname.value = userInfo['nickname'] ?? '';
      final img = userInfo['profile_image'];
      if (img != null && img.toString().isNotEmpty) {
        profileImageUrl.value = img;
      } else {
        profileImageUrl.value = 'assets/images/default_profile.png';
      }
    }
  }

  Future<void> loadStudyDates() async {
    try {
      final userInfo = await _userRepository.fetchUserInfo();
      if (userInfo != null && userInfo['monthly_study_date'] != null) {
        final List<dynamic> studyDates = userInfo['monthly_study_date'];
        monthlyStudyDate.value = studyDates.map((date) => date as int).toList();
        attendanceCount.value = monthlyStudyDate.length;
      }
    } catch (e) {
      print('학습 일자 로드 실패: $e');
      Get.snackbar('오류', '학습 일자를 불러오는데 실패했습니다.');
    }
  }

  void generateCalendar(int year, int month) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final startOffset = firstDayOfMonth.weekday % 7;
    final startDay = firstDayOfMonth.subtract(Duration(days: startOffset));

    List<DateTime> days = [];
    for (int i = 0; i < 42; i++) {
      days.add(startDay.add(Duration(days: i)));
    }

    calendarDates.value = days;
  }

  void logout() {
    print('로그아웃 처리됨');
    Get.offAllNamed('/login');
  }

  Future<void> withdraw() async {
    final result = await _userRepository.deleteAccount();
    if (result) {
      Get.offAllNamed('/login');
      Get.snackbar('탈퇴 완료', '회원 탈퇴가 정상적으로 처리되었습니다.');
    } else {
      Get.snackbar('탈퇴 실패', '회원 탈퇴에 실패했습니다.');
    }
  }
}
