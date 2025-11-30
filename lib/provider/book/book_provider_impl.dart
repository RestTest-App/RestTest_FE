import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/provider/book/book_provider.dart';
import 'package:rest_test/app/factory/secure_storage_factory.dart';
import 'package:rest_test/utility/function/log_util.dart';

class BookProviderImpl extends BaseConnect implements BookProvider {
  late final dio.Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    _dio = dio.Dio();
    _dio.options.baseUrl = httpClient.baseUrl ?? '';
  }
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

  @override
  Future<bool> deleteStudyBook(int studybookId) async {
    try {
      final response = await delete(
        '/api/v1/studybook/delete-my-studybook/$studybookId',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('문제집 삭제 실패');
      }
    } catch (e) {
      throw Exception('문제집 삭제 중 오류 발생: $e');
    }
  }

  @override
  Future<void> createStudyBook({
    required XFile file,
    required String studyBookName,
    required List<Map<String, dynamic>> answers,
    int? questionCount,
  }) async {
    try {
      // FormData 생성
      final formData = dio.FormData();

      // 파일 확장자 추출
      final fileExtension = file.name.split('.').last;

      // 파일명을 사용자 입력 이름으로 변경 (Backend에서 파일명을 문제집 이름으로 사용)
      final newFileName = '$studyBookName.$fileExtension';

      // 파일 추가 (백엔드의 file 파라미터와 매칭)
      final multipartFile = await dio.MultipartFile.fromFile(
        file.path,
        filename: newFileName,
      );
      formData.files.add(MapEntry('file', multipartFile));

      // 쿼리 파라미터 구성 (선택사항)
      final queryParams = <String, dynamic>{};

      // 정답 JSON 문자열로 변환 (빈 배열이 아닐 때만)
      if (answers.isNotEmpty) {
        queryParams['answers'] = jsonEncode(answers);
      }

      // 문제 개수 추가 (선택사항)
      if (questionCount != null && questionCount > 0) {
        queryParams['question_count'] = questionCount;
      }

      // 토큰 가져오기
      final token = await _getAuthToken();

      // 디버그 로깅
      LogUtil.info('[createStudyBook] FormData fields: ${formData.fields}');
      LogUtil.info('[createStudyBook] FormData files: ${formData.files}');
      LogUtil.info('[createStudyBook] Query params: $queryParams');
      LogUtil.info('[createStudyBook] Token: ${token?.isNotEmpty == true ? "***" : "null"}');

      // Dio를 통한 직접 POST 요청
      // 단일 이미지 업로드이므로 upload-my-studybook-by-img 엔드포인트 사용
      // 쿼리 파라미터가 있으면 URL에 직접 추가
      String endpoint = '/api/v1/studybook/upload-my-studybook-by-img';
      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
        endpoint += '?$queryString';
      }

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      LogUtil.info('[createStudyBook] Response status: ${response.statusCode}');
      LogUtil.info('[createStudyBook] Response data: ${jsonEncode(response.data)}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        // 에러 응답 상세 정보
        final errorMsg = response.data is Map ? response.data['detail'] ?? response.data.toString() : response.data.toString();
        LogUtil.error('[createStudyBook] Error detail: $errorMsg');
        throw Exception('문제집 생성 실패: $errorMsg');
      }
    } catch (e) {
      LogUtil.error('[createStudyBook] Error: $e');
      if (e is dio.DioException) {
        LogUtil.error('[createStudyBook] DioException status: ${e.response?.statusCode}');
        LogUtil.error('[createStudyBook] DioException data: ${e.response?.data}');
        LogUtil.error('[createStudyBook] DioException message: ${e.message}');
      }
      throw Exception('문제집 생성 중 오류 발생: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchStudyBookDetail(int studybookId) async {
    try {
      final response = await get('/api/v1/studybook/my_studybook/$studybookId');
      if (response.statusCode == 200 && response.body['data'] != null) {
        return response.body['data'];
      } else {
        throw Exception('Failed to load studybook detail');
      }
    } catch (e) {
      LogUtil.error('[fetchStudyBookDetail] Error: $e');
      throw Exception('문제집 상세 조회 실패: $e');
    }
  }

  Future<String?> _getAuthToken() async {
    try {
      final tokenProvider = SecureStorageFactory.tokenProvider;
      return tokenProvider.accessToken;
    } catch (e) {
      return null;
    }
  }
}
