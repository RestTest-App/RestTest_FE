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

List<GetPage> appPages = [
  // TODO(ALL) : (홈/복습/문제집/마이페이지 메인 화면 제외) 페이지 추가하기 전에 GetPage 설정하기
  GetPage(
      name: Routes.ON_BOARDING,
      page: () => OnboardingScreen(),
      binding: OnboardingBinding()),
  GetPage(
    name: Routes.ROOT,
    page: () => RootScreen(),
    binding: RootBinding(),
    // middlewares: [
    //   LoginMiddleware(),
    //   OnboardingMiddleware(),
    // ],
  ),
  GetPage(
      name: Routes.TEST,
      page: () => TestScreen(),
      binding: TestBinding()
  ),
  GetPage(
      name: Routes.TEST_EXAM,
      page: () => TestExamScreen(),
      binding: TestExamBinding()
  ),
  GetPage(
      name: Routes.TEST_RESULT,
      page: () => TestResultScreen(),
      binding: TestResultBinding()
  ),
  GetPage(
      name: Routes.TEST_COMMENT,
      page: () => TestCommentScreen(),
      binding: TestCommentBinding()
  ),
  GetPage(
    name: Routes.REVIEW_ITEM,
    page: () => ReviewContentScreen(),
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
  )
];
