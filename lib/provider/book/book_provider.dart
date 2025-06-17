import 'package:dio/dio.dart';

abstract class BookProvider{
  Future<List<dynamic>> fetchStudyBooks();
  // Future<void> uploadStudyBook(FormData data);
  Future<void> uploadStudyBook(int id);

}