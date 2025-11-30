import 'package:rest_test/model/goal/goal_progress.dart';
import 'package:rest_test/provider/goal/goal_provider.dart';
import 'package:rest_test/repository/goal/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalProvider _goalProvider;

  GoalRepositoryImpl(this._goalProvider);

  @override
  Future<GoalProgressResponse?> fetchAllGoalsProgress() {
    return _goalProvider.getAllGoalsProgress();
  }

  @override
  Future<GoalProgress?> fetchGoalProgress(int goalId) {
    return _goalProvider.getGoalProgress(goalId);
  }
}
