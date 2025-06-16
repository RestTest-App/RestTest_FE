abstract class TestProvider{
  Future<dynamic> readTestInfo(int examId);
  Future<List<dynamic>> readQuestionList(int examId);
}