abstract class TodayProvider{
  Future<dynamic> createTodayTest(int certificateId);
  Future<Map<String, dynamic>> fetchTodayTest();
  Future<dynamic> sendTodayTest();
}