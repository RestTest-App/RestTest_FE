import 'package:dio/dio.dart';
import '../../model/book/BookListState.dart';

abstract class BookRepository {
  Future<List<StudyBook>> fetchStudyBooks();
  // Future<void> uploadStudyBook(FormData data);
  Future<void> uploadStudyBook(int id);
}