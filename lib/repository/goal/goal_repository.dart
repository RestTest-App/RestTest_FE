import 'package:rest_test/model/goal/goal_progress.dart';
import 'package:rest_test/provider/goal/goal_provider.dart';

abstract class GoalRepository {
  final GoalProvider _goalProvider;

  GoalRepository(this._goalProvider);

  Future<GoalProgressResponse?> fetchAllGoalsProgress();
  Future<GoalProgress?> fetchGoalProgress(int goalId);
}
