import 'package:rest_test/model/goal/goal_progress.dart';
import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/provider/goal/goal_provider.dart';

class GoalProviderImpl extends BaseConnect implements GoalProvider {
  @override
  Future<GoalProgressResponse?> getAllGoalsProgress() async {
    try {
      final response = await get('/api/v1/user/goals/progress');
      if (response.status.isOk) {
        final data = response.body['data'];
        if (data != null) {
          return GoalProgressResponse.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      print('⚠️ 목표 진행도 조회 실패: $e');
      return null;
    }
  }

  @override
  Future<GoalProgress?> getGoalProgress(int goalId) async {
    try {
      final response = await get('/api/v1/user/goals/progress/$goalId');
      if (response.status.isOk) {
        final data = response.body['data'];
        if (data != null) {
          return GoalProgress.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      print('⚠️ 목표 진행도 조회 실패: $e');
      return null;
    }
  }
}
