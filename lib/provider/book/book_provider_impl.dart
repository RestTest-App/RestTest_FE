import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/provider/book/book_provider.dart';

class BookProviderImpl extends BaseConnect implements BookProvider {
  @override
  Future<List<dynamic>> fetchStudyBooks() async {
    try {
      final response = await get('/api/v1/studybook/my_studybook');
      if (response.statusCode == 200 && response.body['data'] != null) {
        return response.body['data']['studybooks'];
      } else {
        if (response.statusCode == 401) {
          return [];
        }
        throw Exception('Failed to load studybooks');
      }
    } catch (e) {
      // 네트워크 오류나 기타 예외 시 빈 리스트 반환
      return [];
    }
  }

  // @override
  // Future<void> uploadStudyBook() async {
  //   final dio = Dio();
  //   final response = await dio.post(
  //     '/api/v1/studybook/upload-my-studybook-by-dummy',
  //     data: data,
  //     options: Options(headers: {'Content-Type': 'multipart/form-data'}),
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('PDF 업로드 실패');
  //   }
  // }

  @override
  Future<void> uploadStudyBook(int questionId) async {
    final response = await post(
      '/api/v1/studybook/upload-my-studybook-by-dummy',
      {
        "id": questionId,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('이미지 업로드 실패');
    }
  }
}
