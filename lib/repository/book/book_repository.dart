import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/book/BookListState.dart';

abstract class BookRepository {
  Future<List<StudyBook>> fetchStudyBooks();
  // Future<void> uploadStudyBook(FormData data);
  Future<void> uploadStudyBook(int id);
  Future<bool> deleteStudyBook(int studybookId);
  Future<void> createStudyBook({
    required XFile file,
    required String studyBookName,
    required List<Map<String, dynamic>> answers,
    int? questionCount,
  });
  Future<Map<String, dynamic>> fetchStudyBookDetail(int studybookId);
}