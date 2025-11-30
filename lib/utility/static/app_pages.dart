import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:rest_test/view/onboarding/login_screen.dart';
import 'package:rest_test/view/onboarding/onboarding_screen.dart';
import 'package:rest_test/view/review/review_content_screen.dart';
import 'package:rest_test/view/review/review_screen.dart';
import 'package:rest_test/view/test/test_comment_screen.dart';
import 'package:rest_test/view/test/test_exam_screen.dart';
import 'package:rest_test/view/test/test_result_screen.dart';
import 'package:rest_test/view/test/test_screen.dart';
import 'package:rest_test/binding/root_binding.dart';
import 'package:rest_test/view/root/root_screen.dart';
import 'package:rest_test/utility/static/app_routes.dart';
import 'package:rest_test/view/today/today_test_comment_screen.dart';
import 'package:rest_test/view/today/today_test_exam_screen.dart';
import 'package:rest_test/view/today/today_test_screen.dart';
import 'package:rest_test/view/goal/goal_setting_screen.dart';
import 'app_routes.dart';

List<GetPage> appPages = [
  // TODO(ALL) : (홈/복습/문제집/마이페이지 메인 화면 제외) 페이지 추가하기 전에 GetPage 설정하기
  GetPage(
      name: Routes.ON_BOARDING,
      page: () => OnboardingScreen(),
      binding: OnboardingBinding()),
  GetPage(
    name: Routes.ROOT,
    page: () => const RootScreen(),
    binding: RootBinding(),
    // middlewares: [
    //   LoginMiddleware(),
    //   OnboardingMiddleware(),
    // ],
  ),
  GetPage(
      name: Routes.TEST,
      page: () => const TestScreen(),
      binding: TestBinding()),
  GetPage(
      name: Routes.TEST_EXAM,
      page: () => const TestExamScreen(),
      binding: TestExamBinding()),
  GetPage(
      name: Routes.TEST_RESULT,
      page: () => const TestResultScreen(),
      binding: TestResultBinding()),
  GetPage(
      name: Routes.TEST_COMMENT,
      page: () => const TestCommentScreen(),
      binding: TestCommentBinding()),
  GetPage(
    name: Routes.REVIEW_ITEM,
    page: () => const ReviewContentScreen(),
    binding: ReviewContentBinding(),
  ),
  GetPage(
    name: Routes.REVIEW,
    page: () => ReviewScreen(),
    binding: ReviewBinding(),
  ),
  GetPage(
    name: Routes.LOGIN,
    page: () => LoginScreen(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: Routes.TODAY,
    page: () => const TodayTestScreen(),
    binding: TodayTestBinding(),
  ),
  GetPage(
    name: Routes.TODAY_EXAM,
    page: () => const TodayTestExamScreen(),
    binding: TodayTestExamBinding(),
  ),
  GetPage(
    name: Routes.TODAY_COMMENT,
    page: () => const TodayTestCommentScreen(),
    binding: TodayTestCommentBinding(),
  ),
  GetPage(
    name: Routes.GOAL_SETTING,
    page: () => const GoalSettingScreen(),
    binding: GoalSettingBinding(),
  ),
];
