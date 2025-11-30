import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:rest_test/app/factory/secure_storage_factory.dart';
import 'package:rest_test/utility/function/log_util.dart';
import 'package:rest_test/provider/token/token_provider.dart';
import 'package:rest_test/utility/static/app_routes.dart';

abstract class BaseConnect extends GetConnect {
  final TokenProvider tokenProvider = SecureStorageFactory.tokenProvider;

  @override
  void onInit() {
    super.onInit();
    httpClient
      ..baseUrl = "${dotenv.env['SERVER_HOST']}:${dotenv.env['SERVER_PORT']}"
      ..timeout = const Duration(seconds: 30)
      ..addRequestModifier<dynamic>((request) {
        if (tokenProvider.accessToken != null) {
          request.headers['Authorization'] =
              'Bearer ${tokenProvider.accessToken}';
          LogUtil.info(
              "🔑 Authorization Token: Bearer ${tokenProvider.accessToken}");
          LogUtil.info("🔑 Request Headers: ${request.headers}");
        } else {
          LogUtil.error("⚠️ No Authorization Token available");
        }
        LogUtil.info("🛫 [${request.method}] ${request.url}");
        return request;
      })
      ..addResponseModifier((request, response) {
        final body = response.body;

        if (response.status.hasError) {
          String code = response.statusCode.toString();
          String message = response.statusText ?? '';

          if (body is Map<String, dynamic> && body['error'] is Map) {
            final err = body['error'] as Map;
            code = err['code']?.toString() ?? code;
            message = err['message']?.toString() ?? message;
          }

          // 401 오류 시 토큰 만료 처리
          if (response.statusCode == 401) {
            // 토큰 클리어
            tokenProvider.clearTokens();
            // 로그인 화면으로 리다이렉트 (한 번만 실행되도록 체크)
            Future.microtask(() {
              try {
                if (Get.currentRoute != Routes.LOGIN) {
                  Get.offAllNamed(Routes.LOGIN);
                }
              } catch (e) {
                // 이미 리다이렉트 중이면 무시
              }
            });
            return response;
          }

          LogUtil.error(
            "🚨 [${request.method}] ${request.url} | FAILED ($code, $message)",
          );
          LogUtil.error("🚨 Response Body: $body");
        } else {
          LogUtil.info(
            "🛬 [${request.method}] ${request.url} | SUCCESS (${response.statusCode})",
          );
          LogUtil.info("🛬 Response Body: $body");
        }

        return response;
      });
  }
}
