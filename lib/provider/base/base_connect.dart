import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_connect/connect.dart';
import 'package:rest_test/app/factory/secure_storage_factory.dart';
import 'package:rest_test/utility/function/log_util.dart';
import 'package:rest_test/provider/token/token_provider.dart';

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
