import 'package:rest_test/provider/today/today_provider.dart';

import '../base/base_connect.dart';

class TodayProviderImpl extends BaseConnect implements TodayProvider{

  @override
  Future<Map<String, dynamic>> fetchTodayTest() async {
    final response = await get('/api/v1/test/today-questions');
    if (response.statusCode == 200 && response.body['data'] != null) {
      return response.body['data'];
    } else {
      throw Exception("오늘의 문제 호출 실패: ${response.body}");
    }
  }

  @override
  Future createTodayTest(int certificateId) async {
    try {
      final response = await post(
        '/api/v1/test/create-today-questions/${certificateId}',
        {}
      );

      if (response.statusCode == 200 || response.statusCode == 409) {
        return response.body;
      } else {
        throw Exception("Invalid response: ${response.body}");
      }
    } catch(e) {
      print('createTodayTest error: $e');
      rethrow;
    }
  }

  @override
  Future sendTodayTest() async{
    try {
      final response = await post(
        '/api/v1/test/submit-today-questions',
        {}
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("Invalid response: ${response.body}");
      }
    } catch(e) {
      print('createTodayTest error: $e');
      rethrow;
    }
  }

}