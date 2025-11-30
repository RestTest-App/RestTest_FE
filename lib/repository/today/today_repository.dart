import '../../model/today/TodayTestState.dart';

abstract class TodayRepository {
  Future<void> createTodayTest(int certificateId);
  Future<TodayTestState> getTodayTest();
  Future<void> sendTodayTest();
}
