enum GoalStatus {
  achieved,
  inProgress,
}

enum GoalType {
  dailyProblem,
  dailyAccuracy,
  consecutiveStudyDays,
}

class GoalProgress {
  final int id;
  final String name;
  final GoalType type;
  final double targetValue;
  final double currentValue;
  final double achievementRate; // 0.0 ~ 100.0
  final GoalStatus status;
  final String description;

  GoalProgress({
    required this.id,
    required this.name,
    required this.type,
    required this.targetValue,
    required this.currentValue,
    required this.achievementRate,
    required this.status,
    required this.description,
  });

  factory GoalProgress.fromJson(Map<String, dynamic> json) {
    return GoalProgress(
      id: json['goal_id'] as int? ?? json['id'] as int,
      name: json['goal_name'] as String? ?? json['name'] as String,
      type: _parseGoalType(
          json['goal_type'] as String? ?? json['type'] as String),
      targetValue: (json['target_value'] as num).toDouble(),
      currentValue:
          (json['current_progress'] as num? ?? json['current_value'] as num)
              .toDouble(),
      achievementRate:
          (json['progress_percent'] as num? ?? json['achievement_rate'] as num)
              .toDouble(),
      status: _parseGoalStatus(
          json['is_achieved'] as bool? ?? json['status'] as String?),
      description:
          json['description'] as String? ?? json['goal_name'] as String? ?? '',
    );
  }

  static GoalType _parseGoalType(String type) {
    switch (type) {
      case 'daily_problem':
        return GoalType.dailyProblem;
      case 'daily_accuracy':
        return GoalType.dailyAccuracy;
      case 'consecutive_study_days':
        return GoalType.consecutiveStudyDays;
      default:
        return GoalType.dailyProblem; // fallback
    }
  }

  static GoalStatus _parseGoalStatus(dynamic status) {
    if (status is bool) {
      return status ? GoalStatus.achieved : GoalStatus.inProgress;
    }
    if (status is String) {
      switch (status) {
        case 'ACHIEVED':
        case 'achieved':
        case 'true':
          return GoalStatus.achieved;
        default:
          return GoalStatus.inProgress;
      }
    }
    return GoalStatus.inProgress;
  }
}

class GoalSummary {
  final int achievedCount;
  final int totalCount;
  final double achievementRate;

  GoalSummary({
    required this.achievedCount,
    required this.totalCount,
    required this.achievementRate,
  });

  factory GoalSummary.fromJson(Map<String, dynamic> json) {
    return GoalSummary(
      achievedCount:
          json['achieved_goals'] as int? ?? json['achieved_count'] as int,
      totalCount: json['total_goals'] as int? ?? json['total_count'] as int,
      achievementRate:
          (json['overall_progress'] as num? ?? json['achievement_rate'] as num)
              .toDouble(),
    );
  }
}

class GoalProgressResponse {
  final GoalSummary summary;
  final List<GoalProgress> goals;

  GoalProgressResponse({
    required this.summary,
    required this.goals,
  });

  factory GoalProgressResponse.fromJson(Map<String, dynamic> json) {
    // 백엔드 응답 형식에 맞춰 summary 생성
    final summary = GoalSummary(
      achievedCount: json['achieved_goals'] as int? ?? 0,
      totalCount: json['total_goals'] as int? ?? 0,
      achievementRate: (json['overall_progress'] as num? ?? 0.0).toDouble(),
    );

    final goalsJson = json['goals'] as List<dynamic>? ?? [];
    final goals = goalsJson
        .map((e) => GoalProgress.fromJson(e as Map<String, dynamic>))
        .toList();

    return GoalProgressResponse(
      summary: summary,
      goals: goals,
    );
  }
}
