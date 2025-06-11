import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:rest_test/view/onboarding/onboarding_screen.dart';
import 'package:rest_test/view/test/test_comment_screen.dart';
import 'package:rest_test/view/test/test_exam_screen.dart';
import 'package:rest_test/view/test/test_result_screen.dart';
import 'package:rest_test/view/test/test_screen.dart';
import '../../binding/root_binding.dart';
import '../../view/root/root_screen.dart';
import 'app_routes.dart';

List<GetPage> appPages = [
  // TODO(ALL) : (홈/복습/문제집/마이페이지 메인 화면 제외) 페이지 추가하기 전에 GetPage 설정하기
  GetPage(
    name: Routes.ON_BOARDING, 
    page: () => OnboardingScreen(),
    binding: OnboardingBinding()
  ),
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
  )
];