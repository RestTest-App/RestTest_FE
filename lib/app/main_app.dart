import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/static/app_pages.dart';
import 'package:rest_test/utility/static/app_routes.dart';
import 'package:rest_test/utility/system/color_system.dart';

class MainApp extends StatelessWidget {
  final bool hasRefreshToken;

  const MainApp({Key? key, required this.hasRefreshToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GetMaterialApp(
      // App Title
      title: "Rest_Test",

      locale: Get.deviceLocale,
      fallbackLocale: const Locale('ko', 'KR'),

      // Theme
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "AppleSDGothicNeo",
        colorSchemeSeed: ColorSystem.blue, //
        scaffoldBackgroundColor: ColorSystem.blue,
      ),

      initialRoute: hasRefreshToken ? Routes.ROOT : Routes.LOGIN,
      // initialRoute: Routes.LOGIN, // 로그인 화면으로 시작(TEST)
      // initialRoute: Routes.ROOT,
      // initialBinding: InitBinding(),
      getPages: appPages,
    );
  }
}
