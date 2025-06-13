import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_connect/connect.dart';
import '../../app/factory/secure_storage_factory.dart';
import '../../utility/function/log_util.dart';
import '../token/token_provider.dart';

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
        } else {
          LogUtil.info(
            "🛬 [${request.method}] ${request.url} | SUCCESS (${response.statusCode})",
          );
          LogUtil.info("🛬 BODY ${body}");
        }

        return response;
      });
  }
}
