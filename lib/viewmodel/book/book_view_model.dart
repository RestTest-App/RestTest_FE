import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../repository/book/book_repository.dart';
import '../root/root_view_model.dart';

class BookViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // Dependency Injection Fields, if needed
  late final RootViewModel _rootViewModel;
  late final BookRepository _bookRepository;
  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  // Private fields for internal logic
  var isLoading = false.obs;

  // 임시 저장 필드 - 문제집 생성 진행 중
  XFile? _selectedImage;
  String? _studyBookName;
  final _answers = <Map<String, dynamic>>[].obs;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */

  var files = <Map<String, dynamic>>[].obs;
  var total = 0.obs;
  var remainingCount = 2.obs;

  // 드롭다운 선택 값
  var dropdownItems = ['최근 생성순', '가나다순', '최근 학습순'];
  var selectedValue = '최근 생성순'.obs;

  @override
  void onInit() {
    super.onInit();
    _rootViewModel = Get.find<RootViewModel>();
    _bookRepository = Get.find<BookRepository>();
    fetchBooks().catchError((error) {});
  }

  // 드롭다운 값 업데이트
  void updateSelectedValue(String? newValue) {
    if (newValue != null) {
      selectedValue.value = newValue;
    }
  }

  // 파일 목록에 파일 추가
  void addFile(String name, String date) {
    files.add({'name': name, 'date': date});
    total.value = files.length;
  }

  Future<void> fetchBooks() async {
    try {
      final books = await _bookRepository.fetchStudyBooks();
      files.value = books
          .map((e) => {
                'id': e.id,
                'name': e.name,
                'date': e.CreatedAt.toIso8601String().split('T').first,
                'color': e.FileColor,
              })
          .toList();
      total.value = books.length;
    } catch (e) {
      // 토큰 만료나 네트워크 오류 시 빈 리스트로 처리
      files.value = [];
      total.value = 0;
    }
  }

  Future<void> uploadPdf(int id) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      isLoading.value = true;
      try {
        await _bookRepository.uploadStudyBook(id);
        await Future.delayed(const Duration(seconds: 1));
        await fetchBooks();
      } catch (e) {
        // 업로드 실패 시 에러 처리
        rethrow;
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<bool> deleteStudyBook(int studybookId) async {
    try {
      isLoading.value = true;
      final result = await _bookRepository.deleteStudyBook(studybookId);
      if (result) {
        // 삭제 성공 후 목록 갱신
        await fetchBooks();
        Get.snackbar('성공', '문제집이 삭제되었습니다.');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('삭제 실패', '문제집 삭제에 실패했습니다.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 이미지/PDF 선택 및 임시 저장
  Future<bool> selectImage() async {
    final ImagePicker picker = ImagePicker();

    // 먼저 이미지 선택 시도
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      _selectedImage = image;
      return true;
    }

    // 이미지 선택 취소 시 PDF 선택 옵션 제공
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      _selectedImage = XFile(file.path!);
      return true;
    }

    return false;
  }

  // 파일 선택 설정
  void setSelectedFile(XFile file) {
    _selectedImage = file;
  }

  // 문제집 이름 저장
  void setStudyBookName(String name) {
    _studyBookName = name;
  }

  // 임시 저장된 이미지 반환
  XFile? getSelectedImage() {
    return _selectedImage;
  }

  // 임시 저장된 이름 반환
  String? getStudyBookName() {
    return _studyBookName;
  }

  // 문제집 생성 (이미지 + 이름과 함께 API 호출)
  Future<bool> createStudyBook({
    required String studyBookName,
    required List<Map<String, dynamic>> answers,
    int? questionCount,
  }) async {
    if (_selectedImage == null) {
      Get.snackbar('오류', '이미지를 선택해주세요.');
      return false;
    }

    try {
      isLoading.value = true;
      await _bookRepository.createStudyBook(
        file: _selectedImage!,
        studyBookName: studyBookName,
        answers: answers,
        questionCount: questionCount,
      );

      // 임시 저장 초기화
      _selectedImage = null;
      _studyBookName = null;

      // 목록 갱신
      await fetchBooks();
      Get.snackbar('성공', '문제집이 생성되었습니다.');

      // 모달 닫기 (이미 다이얼로그는 닫혔음)
      Get.back();

      return true;
    } catch (e) {
      Get.snackbar('생성 실패', '문제집 생성에 실패했습니다.\n$e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 임시 저장 데이터 초기화
  void clearTemporaryData() {
    _selectedImage = null;
    _studyBookName = null;
  }

  // 문제집 상세 정보 조회
  Future<Map<String, dynamic>> fetchStudyBookDetail(int studybookId) async {
    final detail = await _bookRepository.fetchStudyBookDetail(studybookId);
    return detail;
  }
}
