import 'package:rest_test/model/goal/goal_progress.dart';

abstract class GoalProvider {
  Future<GoalProgressResponse?> getAllGoalsProgress();
  Future<GoalProgress?> getGoalProgress(int goalId);
}
