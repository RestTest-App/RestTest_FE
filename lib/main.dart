import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:rest_test/app/factory/secure_storage_factory.dart';

import 'app/main_app.dart';

Future<void> main() async {
  await onSystemInit();

  const bool hasRefreshToken = false;
  runApp(const MainApp(
    hasRefreshToken: hasRefreshToken,
  ));
}

Future<void> onSystemInit() async {
  // WidgetsBinding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // 스플래시
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // SecureStorageFactory 초기화
  await SecureStorageFactory().onInit();

  // Environment
  await dotenv.load(fileName: "assets/config/.env");
  KakaoSdk.init(nativeAppKey: "${dotenv.env['KAKAO_NATIVE_APP_KEY']}");

  // 스플래시 스크린 제거
  FlutterNativeSplash.remove();
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
