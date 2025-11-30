import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rest_test/provider/book/book_provider.dart';
import 'package:rest_test/repository/book/book_repository.dart';

import '../../model/book/BookListState.dart';

class BookRepositoryImpl extends GetxService implements BookRepository{
  late final BookProvider _bookProvider;

  @override
  void onInit() {
    super.onInit();
    _bookProvider = Get.find<BookProvider>();
  }

  @override
  Future<List<StudyBook>> fetchStudyBooks() async {
    final raw = await _bookProvider.fetchStudyBooks();
    return raw.map((e) => StudyBook(
      id: e['id'],
      name: e['name'],
      questionCount: e['question_count'],
      FileColor: e['file_color'],
      CreatedAt: DateTime.parse(e['created_at']),
    )).toList();
  }

  @override
  // Future<void> uploadStudyBook(data) async {
  //   await _bookProvider.uploadStudyBook(data);
  // }
  Future<void> uploadStudyBook(int id) async {
    await _bookProvider.uploadStudyBook(id);
  }

  @override
  Future<bool> deleteStudyBook(int studybookId) async {
    return await _bookProvider.deleteStudyBook(studybookId);
  }

  @override
  Future<void> createStudyBook({
    required XFile file,
    required String studyBookName,
    required List<Map<String, dynamic>> answers,
    int? questionCount,
  }) async {
    await _bookProvider.createStudyBook(
      file: file,
      studyBookName: studyBookName,
      answers: answers,
      questionCount: questionCount,
    );
  }

  @override
  Future<Map<String, dynamic>> fetchStudyBookDetail(int studybookId) async {
    return await _bookProvider.fetchStudyBookDetail(studybookId);
  }
}