import 'package:get/get_navigation/src/routes/get_route.dart';
import '../../binding/root_binding.dart';
import '../../view/root/root_screen.dart';
import 'app_routes.dart';

List<GetPage> appPages = [
  // TODO(ALL) : (홈/복습/문제집/마이페이지 메인 화면 제외) 페이지 추가하기 전에 GetPage 설정하기
  GetPage(
    name: Routes.ROOT,
    page: () => const RootScreen(),
    binding: RootBinding(),
    // middlewares: [
    //   LoginMiddleware(),
    //   OnboardingMiddleware(),
    // ],
  ),
];