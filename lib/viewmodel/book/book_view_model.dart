import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
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
    fetchBooks();
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
    final books = await _bookRepository.fetchStudyBooks();
    files.value = books.map((e) => {
      'name': e.name,
      'date': e.CreatedAt.toIso8601String().split('T').first,
      'color': e.FileColor,
    }).toList();
    total.value = books.length;
  }

  Future<void> uploadPdf(int id) async {
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf'],
    // );
    //
    // if (result != null && result.files.single.path != null) {
    //   final file = result.files.single;
    //
    //   final formData = dio.FormData.fromMap({
    //     'file': await dio.MultipartFile.fromFile(file.path!, filename: file.name),
    //   });
    //
    //   await _bookRepository.uploadStudyBook(formData);
    //   await fetchBooks(); // 업로드 성공 후 문제집 목록 갱신
    // }
    isLoading.value = true;
    try {
      await _bookRepository.uploadStudyBook(id);
      await Future.delayed(const Duration(seconds: 1));
      await fetchBooks();
    } finally {
      isLoading.value = false;
    }
  }

}
