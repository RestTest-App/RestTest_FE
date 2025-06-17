import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:rest_test/repository/today/today_repository.dart';
import '../../model/today/TodayTestState.dart';
import '../../provider/today/today_provider.dart';

class TodayRepositoryImpl extends GetxService implements TodayRepository {
  late final TodayProvider _todayProvider;

  void onInit() {
    super.onInit();
    _todayProvider = Get.find<TodayProvider>();
  }

  @override
  Future<TodayTestState> getTodayTest() async {
    final json = await _todayProvider.fetchTodayTest();
    return TodayTestState.fromJson(json);
  }

  @override
  Future<void> createTodayTest(int certificateId) async {
    return await _todayProvider.createTodayTest(certificateId);
  }

  @override
  Future<void> sendTodayTest() async{
    return await _todayProvider.sendTodayTest();
  }
}