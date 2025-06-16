import 'package:rest_test/model/test/Question.dart';
import 'package:rest_test/model/test/TestInfoState.dart';

abstract class TestRepository {
  Future<TestInfoState> readTestInfo(int examId);
  Future<List<Question>> readQuestionList(int examId);
}