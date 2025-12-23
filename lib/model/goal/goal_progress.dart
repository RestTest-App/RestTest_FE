import 'package:flutter/foundation.dart';

enum GoalStatus {
  achieved,
  inProgress,
}

enum GoalType {
  dailyProblem,
  dailyAccuracy,
  consecutiveStudyDays,
}

/// Goal 설정 정보 (goal_id와 실제 값의 매핑)
class GoalConfig {
  final int id; // goal_id (1~9)
  final String name; // 목표명
  final GoalType type; // enum
  final double targetValue; // 10/70/3...
  final String description; // 설명

  const GoalConfig({
    required this.id,
    required this.name,
    required this.type,
    required this.targetValue,
    required this.description,
  });
}

/// Goal 설정 테이블
class GoalConfigs {
  static const Map<int, GoalConfig> byId = {
    1: GoalConfig(
      id: 1,
      name: '하루에 10문제',
      type: GoalType.dailyProblem,
      targetValue: 10,
      description: '오늘 10문제를 풀어보세요',
    ),
    2: GoalConfig(
      id: 2,
      name: '하루에 15문제',
      type: GoalType.dailyProblem,
      targetValue: 15,
      description: '오늘 15문제를 풀어보세요',
    ),
    3: GoalConfig(
      id: 3,
      name: '하루에 20문제',
      type: GoalType.dailyProblem,
      targetValue: 20,
      description: '오늘 20문제를 풀어보세요',
    ),
    4: GoalConfig(
      id: 4,
      name: '정답률 70% 이상',
      type: GoalType.dailyAccuracy,
      targetValue: 70,
      description: '오늘 70% 이상의 정답률을 달성하세요',
    ),
    5: GoalConfig(
      id: 5,
      name: '정답률 80% 이상',
      type: GoalType.dailyAccuracy,
      targetValue: 80,
      description: '오늘 80% 이상의 정답률을 달성하세요',
    ),
    6: GoalConfig(
      id: 6,
      name: '정답률 90% 이상',
      type: GoalType.dailyAccuracy,
      targetValue: 90,
      description: '오늘 90% 이상의 정답률을 달성하세요',
    ),
    7: GoalConfig(
      id: 7,
      name: '연속 3일 학습',
      type: GoalType.consecutiveStudyDays,
      targetValue: 3,
      description: '연속 3일 학습을 완료하세요',
    ),
    8: GoalConfig(
      id: 8,
      name: '연속 5일 학습',
      type: GoalType.consecutiveStudyDays,
      targetValue: 5,
      description: '연속 5일 학습을 완료하세요',
    ),
    9: GoalConfig(
      id: 9,
      name: '연속 7일 학습',
      type: GoalType.consecutiveStudyDays,
      targetValue: 7,
      description: '연속 7일 학습을 완료하세요',
    ),
  };

  static GoalConfig? fromId(int? id) => id == null ? null : byId[id];
}

/// 목표 설정 화면에서 사용하는 목표 아이템
/// 같은 타입의 목표를 여러 개 설정할 수 있도록 함
class GoalItem {
  final GoalType type;
  final double value;
  final String id; // 고유 ID (타입과 값의 조합)
  final int? goalId; // 서버의 goal_id (1-9)

  GoalItem({
    required this.type,
    required this.value,
    this.goalId,
  }) : id = '${type.name}_${value.toInt()}';

  GoalItem copyWith({
    GoalType? type,
    double? value,
    int? goalId,
  }) {
    return GoalItem(
      type: type ?? this.type,
      value: value ?? this.value,
      goalId: goalId ?? this.goalId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
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
    // 디버그: 실제 서버 응답 확인
    debugPrint('🧾 GoalProgress raw json = $json');

    final category = (json['category'] as String? ??
            json['goal_type'] as String? ??
            json['type'] as String? ??
            'daily_problem')
        .toString();

    // 서버가 goal_id를 안 주는 케이스 대응: goal_id를 추론
    // target_value가 4/7로 오면 그것을 goal_id로 추론
    final rawGoalId = (json['goal_id'] as int?) ??
        (json['id'] as int?) ??
        ((json['target_value'] as num?)?.toInt());

    debugPrint('🧾 추론된 goal_id=$rawGoalId, category=$category');

    // GoalConfig에서 설정 정보 가져오기
    final cfg = GoalConfigs.fromId(rawGoalId);

    // 타입 파싱(서버 문자열) — cfg가 있으면 cfg.type을 우선
    final parsedType = _parseGoalType(category);
    final finalType = cfg?.type ?? parsedType;

    // 목표값 — cfg 있으면 cfg.targetValue로 강제, 없으면 서버 target_value 사용
    final targetValue =
        cfg?.targetValue ?? ((json['target_value'] as num? ?? 0).toDouble());

    // 이름 — cfg 있으면 cfg.name 강제, 없으면 서버 값 사용
    final name = cfg?.name ??
        ((json['goal_name'] as String? ?? json['name'] as String? ?? '')
            .toString());

    // 설명 — cfg 있으면 cfg.description 강제, 없으면 서버 값 사용
    final description =
        cfg?.description ?? ((json['description'] as String? ?? '').toString());

    debugPrint(
        '🧾 최종: goal_id=$rawGoalId, type=$finalType, targetValue=$targetValue, name=$name');

    return GoalProgress(
      id: rawGoalId ?? 0,
      name: name,
      type: finalType,
      targetValue: targetValue,
      currentValue: (json['current_progress'] as num? ??
              json['current_value'] as num? ??
              0)
          .toDouble(),
      achievementRate: (json['progress_percent'] as num? ??
              json['achievement_rate'] as num? ??
              0.0)
          .toDouble(),
      status: _parseGoalStatus(json['is_achieved'] ?? json['status']),
      description: description.isNotEmpty ? description : name,
    );
  }

  static GoalType _parseGoalType(String type) {
    switch (type) {
      case 'daily_problem':
        return GoalType.dailyProblem;
      case 'daily_accuracy':
        return GoalType.dailyAccuracy;
      case 'consecutive_days':
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
