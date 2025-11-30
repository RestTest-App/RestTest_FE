import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
}
