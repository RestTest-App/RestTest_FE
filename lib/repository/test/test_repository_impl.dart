import 'package:get/get.dart';
import 'package:rest_test/model/test/Question.dart';
import 'package:rest_test/model/test/TestInfoState.dart';
import 'package:rest_test/provider/test/test_provider.dart';
import 'package:rest_test/repository/test/test_repository.dart';

class TestRepositoryImpl extends GetxService implements TestRepository{
  late final TestProvider _testProvider;

  @override
  void onInit() {
    super.onInit();
    _testProvider = Get.find<TestProvider>();
  }

  @override
  Future<TestInfoState> readTestInfo(int examId) async {
    final Map<String, dynamic> data = await _testProvider.readTestInfo(examId);
    return TestInfoState.fromJson(data);
  }

  @override
  Future<List<Question>> readQuestionList(int examId) async{
    List<dynamic> data = await _testProvider.readQuestionList(examId);
    return List<Question>.from(data.map((q) => Question.fromJson(q)));
  }
  
}