import 'package:dio/dio.dart';
import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/provider/book/book_provider.dart';


class BookProviderImpl extends BaseConnect implements BookProvider{
  @override
  Future<List<dynamic>> fetchStudyBooks() async {
    final response = await get('/api/v1/studybook/my_studybook');
    if (response.statusCode == 200 && response.body['data'] != null) {
      return response.body['data']['studybooks'];
    } else {
      throw Exception('Failed to load studybooks');
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
      throw Exception('PDF 업로드 실패');
    }
  }
}