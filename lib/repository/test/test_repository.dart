import 'package:rest_test/model/test/TestInfoState.dart';

abstract class TestRepository {
  Future<TestInfoState> readTestInfo(int examId);
}