import 'package:get/get_connect/http/src/response/response.dart';
import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/provider/test/test_provider.dart';

class TestProviderImpl extends BaseConnect implements TestProvider{
  @override
  Future<Map<String, dynamic>> readTestInfo(int examId) async {
    Response response;

    try {
      final response = await get('/api/v1/test/exam/$examId/info');

      if (response.statusCode == 200 && response.body != null && response.body['data'] != null) {
        return response.body['data'];
      } else {
        throw Exception("Invalid response: ${response.body}");
      }
    } catch (e) {
      print('readTestInfo error: $e');
      rethrow;
    }
  }

}