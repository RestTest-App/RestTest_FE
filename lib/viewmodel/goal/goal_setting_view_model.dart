import 'package:get/get.dart';
import 'package:rest_test/model/goal/goal_progress.dart';
import 'package:rest_test/repository/user/user_repository.dart';
import 'package:rest_test/repository/goal/goal_repository.dart';
import 'package:rest_test/viewmodel/home/home_view_model.dart';

class GoalSettingViewModel extends GetxController {
  late final UserRepository _userRepository = Get.find();
  late final GoalRepository _goalRepository = Get.find();
  final RxList<GoalItem> _selectedGoals = <GoalItem>[].obs;
  List<GoalItem> _initialGoals = <GoalItem>[];
  final RxMap<int, GoalProgress> _goalProgressMap = <int, GoalProgress>{}.obs;

  List<GoalItem> get selectedGoals => _selectedGoals.toList();

  bool get hasChanges {
    if (_selectedGoals.length != _initialGoals.length) return true;
    // ID 기준으로 비교
    final selectedIds = _selectedGoals.map((g) => g.id).toSet();
    final initialIds = _initialGoals.map((g) => g.id).toSet();
    return !selectedIds.containsAll(initialIds) ||
        !initialIds.containsAll(selectedIds);
  }

  @override
  void onInit() {
    super.onInit();
    // 기존 목표 불러오기 (비동기)
    _loadExistingGoals();
  }

  Future<void> _loadExistingGoals() async {
    try {
      // User 정보에서 goal_table 불러오기
      final userInfo = await _userRepository.fetchUserInfo();
      if (userInfo != null && userInfo['goal_table'] != null) {
        final goalTable = userInfo['goal_table'];
        _selectedGoals.clear();

        if (goalTable is Map) {
          goalTable.forEach((category, goalIdsOrId) {
            if (goalIdsOrId is int) {
              final goalItem = _mapFromGoalId(goalIdsOrId);
              if (goalItem != null) {
                _selectedGoals.add(goalItem);
                // 목표 로드 후 진행도 조회
                _loadGoalProgress(goalIdsOrId);
                print(
                    '✅ 목표 로드: goal_id=$goalIdsOrId, type=${goalItem.type.name}, value=${goalItem.value.toInt()}');
              }
            } else if (goalIdsOrId is List) {
              for (final goalId in goalIdsOrId) {
                if (goalId is int) {
                  final goalItem = _mapFromGoalId(goalId);
                  if (goalItem != null) {
                    _selectedGoals.add(goalItem);
                    // 목표 로드 후 진행도 조회
                    _loadGoalProgress(goalId);
                    print(
                        '✅ 목표 로드: goal_id=$goalId, type=${goalItem.type.name}, value=${goalItem.value.toInt()}');
                  }
                }
              }
            }
          });
          print('✅ User 정보에서 목표 불러오기 완료 (딕셔너리 형식): ${_selectedGoals.length}개');
        } else if (goalTable is List) {
          for (final goalId in goalTable) {
            if (goalId is int) {
              final goalItem = _mapFromGoalId(goalId);
              if (goalItem != null) {
                _selectedGoals.add(goalItem);
                // 목표 로드 후 진행도 조회
                _loadGoalProgress(goalId);
                print(
                    '✅ 목표 로드: goal_id=$goalId, type=${goalItem.type.name}, value=${goalItem.value.toInt()}');
              }
            }
          }
          print('✅ User 정보에서 목표 불러오기 완료 (리스트 형식): ${_selectedGoals.length}개');
        } else {
          print('⚠️ goal_table이 예상하지 못한 형식입니다: ${goalTable.runtimeType}');
          _loadFromHomeViewModel();
        }
      } else {
        print('⚠️ goal_table이 없습니다. HomeViewModel에서 불러오기 시도');
        _loadFromHomeViewModel();
      }

      // 초기 상태 저장 (목표 불러오기 완료 후)
      _initialGoals = List.from(_selectedGoals);
      print('✅ 목표 불러오기 완료: ${_selectedGoals.length}개');
    } catch (e) {
      print('⚠️ 목표 불러오기 실패: $e');
      _loadFromHomeViewModel();
      _initialGoals = List.from(_selectedGoals);
    }
  }

  void _loadFromHomeViewModel() {
    try {
      final homeViewModel = Get.find<HomeViewModel>();
      final existingGoals = homeViewModel.goals;

      _selectedGoals.clear();
      for (final goal in existingGoals) {
        _selectedGoals.add(GoalItem(
          type: goal.type,
          value: goal.targetValue,
        ));
      }

      print('✅ HomeViewModel에서 목표 불러오기 완료: ${_selectedGoals.length}개');
    } catch (e) {
      print('⚠️ HomeViewModel에서 목표 불러오기 실패: $e');
    }
  }

  /// 목표 아이템 매핑
  /// goal_id를 GoalItem으로 역변환
  /// 서버의 GOAL_CONFIGS에 맞춰 GoalType과 value 반환
  GoalItem? _mapFromGoalId(int goalId) {
    switch (goalId) {
      case 1:
        return GoalItem(type: GoalType.dailyProblem, value: 10, goalId: goalId);
      case 2:
        return GoalItem(type: GoalType.dailyProblem, value: 15, goalId: goalId);
      case 3:
        return GoalItem(type: GoalType.dailyProblem, value: 20, goalId: goalId);
      case 4:
        return GoalItem(
            type: GoalType.dailyAccuracy, value: 70, goalId: goalId);
      case 5:
        return GoalItem(
            type: GoalType.dailyAccuracy, value: 80, goalId: goalId);
      case 6:
        return GoalItem(
            type: GoalType.dailyAccuracy, value: 90, goalId: goalId);
      case 7:
        return GoalItem(
            type: GoalType.consecutiveStudyDays, value: 3, goalId: goalId);
      case 8:
        return GoalItem(
            type: GoalType.consecutiveStudyDays, value: 5, goalId: goalId);
      case 9:
        return GoalItem(
            type: GoalType.consecutiveStudyDays, value: 7, goalId: goalId);
      default:
        print('⚠️ 알 수 없는 goal_id: $goalId');
        return null;
    }
  }

  /// 목표 추가 (같은 타입의 목표를 여러 개 추가 가능)
  void addGoal(GoalType type, double value) {
    if (value > 0) {
      final goalId = _mapToGoalId(type, value.toInt());
      final newGoal = GoalItem(type: type, value: value, goalId: goalId);
      // 중복 체크 (같은 타입과 값이면 추가하지 않음)
      if (!_selectedGoals.any((g) => g.id == newGoal.id)) {
        _selectedGoals.add(newGoal);
        // 목표 추가 후 진행도 조회
        if (goalId != null) {
          _loadGoalProgress(goalId);
        }
        print('✅ 목표 추가: ${type.name} ${value.toInt()}');
      }
    }
  }

  /// 개별 목표 진행도 조회
  Future<void> _loadGoalProgress(int goalId) async {
    try {
      final progress = await _goalRepository.fetchGoalProgress(goalId);
      if (progress != null) {
        _goalProgressMap[goalId] = progress;
        print(
            '✅ 목표 진행도 조회 완료: goal_id=$goalId, progress=${progress.achievementRate}%');
      }
    } catch (e) {
      print('⚠️ 목표 진행도 조회 실패: goal_id=$goalId, error=$e');
    }
  }

  /// 특정 목표의 진행도 정보 가져오기
  GoalProgress? getGoalProgress(int? goalId) {
    if (goalId == null) return null;
    return _goalProgressMap[goalId];
  }

  /// 목표 제거
  void removeGoal(String goalId) {
    _selectedGoals.removeWhere((g) => g.id == goalId);
    print('🗑️ 목표 제거: $goalId');
  }

  /// 특정 타입의 목표들 가져오기
  List<GoalItem> getGoalsByType(GoalType type) {
    return _selectedGoals.where((g) => g.type == type).toList();
  }

  /// 하위 호환성을 위한 메서드들 (Deprecated)
  @Deprecated('Use addGoal instead')
  bool isGoalTypeSelected(GoalType type) {
    return _selectedGoals.any((g) => g.type == type);
  }

  @Deprecated('Use getGoalsByType instead')
  double getGoalValue(GoalType type) {
    final goals = getGoalsByType(type);
    return goals.isNotEmpty ? goals.first.value : 0.0;
  }

  @Deprecated('Use addGoal instead')
  void setGoalValue(GoalType type, double value) {
    // 기존 같은 타입의 목표 제거 후 추가
    _selectedGoals.removeWhere((g) => g.type == type);
    addGoal(type, value);
  }

  @Deprecated('Use removeGoal(String goalId) instead')
  void removeGoalByType(GoalType type) {
    _selectedGoals.removeWhere((g) => g.type == type);
  }

  Future<bool> saveGoals() async {
    try {
      // UserRepository를 통해 goal_table 저장
      // 서버는 goal_table을 카테고리별로 정수 하나씩 받도록 스키마가 정의되어 있음
      // 형식: {"daily_problem": 1, "daily_accuracy": 4, "consecutive_days": 7}
      final goalTableMap = <String, int>{};

      // 선택된 목표를 카테고리별로 그룹화
      // 같은 카테고리에 여러 개가 선택되어 있으면 마지막 값으로 덮어쓰기
      for (final goal in _selectedGoals) {
        final goalId = _mapToGoalId(goal.type, goal.value.toInt());
        if (goalId != null) {
          final category = _getCategoryFromType(goal.type);
          if (category != null) {
            goalTableMap[category] = goalId; // 덮어쓰기 정책 (마지막 값 유지)
          }
        }
      }

      // 목표가 하나도 없으면 저장하지 않음
      if (goalTableMap.isEmpty) {
        print('⚠️ 저장할 목표가 없습니다.');
        Get.snackbar('알림', '저장할 목표가 없습니다.');
        return false;
      }

      final requestBody = {'goal_table': goalTableMap};
      print('📤 목표 저장 요청 (goal_table): $requestBody');
      print('📤 선택된 목표 개수: ${_selectedGoals.length}');
      for (final goal in _selectedGoals) {
        print(
            '  - ${goal.type.name}: ${goal.value.toInt()}, goal_id: ${goal.goalId}');
      }

      final success = await _userRepository.updateUserInfo(requestBody);

      if (success) {
        _initialGoals = List.from(_selectedGoals);
        print('✅ 목표 저장 완료');
        // 저장된 목표들의 진행도 다시 조회
        await _refreshAllGoalProgress();
        return true; // 저장 성공
      } else {
        print('⚠️ 목표 저장 실패 - 서버 응답을 확인하세요');
        Get.snackbar('오류', '목표 저장에 실패했습니다.');
        return false; // 저장 실패
      }
    } catch (e) {
      print('⚠️ 목표 저장 중 오류 발생: $e');
      Get.snackbar('오류', '목표 저장 중 오류가 발생했습니다.');
      return false;
    }
  }

  /// GoalType을 서버 카테고리 이름으로 변환
  String? _getCategoryFromType(GoalType type) {
    switch (type) {
      case GoalType.dailyProblem:
        return 'daily_problem';
      case GoalType.dailyAccuracy:
        return 'daily_accuracy';
      case GoalType.consecutiveStudyDays:
        return 'consecutive_days';
    }
  }

  /// GoalType과 value를 goal_id로 매핑
  /// 서버의 GOAL_CONFIGS에 맞춰 goal_id 반환
  int? _mapToGoalId(GoalType type, int value) {
    switch (type) {
      case GoalType.dailyProblem:
        // 일일 문제 풀기: goal_id 1-3
        if (value == 10) return 1;
        if (value == 15) return 2;
        if (value == 20) return 3;
        break;
      case GoalType.dailyAccuracy:
        // 정답률 목표: goal_id 4-6
        if (value == 70) return 4;
        if (value == 80) return 5;
        if (value == 90) return 6;
        break;
      case GoalType.consecutiveStudyDays:
        // 연속 학습: goal_id 7-9
        if (value == 3) return 7;
        if (value == 5) return 8;
        if (value == 7) return 9;
        break;
    }
    return null;
  }

  /// 저장된 모든 목표의 진행도 다시 조회
  Future<void> _refreshAllGoalProgress() async {
    for (final goal in _selectedGoals) {
      if (goal.goalId != null) {
        await _loadGoalProgress(goal.goalId!);
      }
    }
  }

  void refreshHomeGoals() {
    try {
      final homeViewModel = Get.find<HomeViewModel>();
      homeViewModel.loadAllGoalsProgress().catchError((e) {
        print('⚠️ 전체 목표 진행도 조회 실패 (무시): $e');
      });
    } catch (e) {
      print('⚠️ HomeViewModel을 찾을 수 없습니다: $e');
    }
  }
}
