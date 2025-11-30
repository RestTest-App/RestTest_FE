import 'package:get/get.dart';
import 'package:rest_test/model/goal/goal_progress.dart';
import 'package:rest_test/repository/user/user_repository.dart';
import 'package:rest_test/viewmodel/home/home_view_model.dart';

class GoalSettingViewModel extends GetxController {
  late final UserRepository _userRepository = Get.find();
  final Map<GoalType, double> _selectedGoals = <GoalType, double>{}.obs;
  Map<GoalType, double> _initialGoals = <GoalType, double>{};

  Map<GoalType, double> get selectedGoals => _selectedGoals;

  bool get hasChanges {
    if (_selectedGoals.length != _initialGoals.length) return true;
    for (var entry in _selectedGoals.entries) {
      if (_initialGoals[entry.key] != entry.value) return true;
    }
    return false;
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
        if (goalTable is Map<String, dynamic>) {
          // goal_table에서 목표 불러오기
          for (final entry in goalTable.entries) {
            final goalType = _apiStringToGoalType(entry.key);
            if (goalType != null) {
              final value = entry.value;
              if (value is num) {
                _selectedGoals[goalType] = value.toDouble();
              }
            }
          }
          print('✅ User 정보에서 목표 불러오기 완료: $_selectedGoals');
        }
      } else {
        // Fallback: HomeViewModel에서 불러오기 시도
        _loadFromHomeViewModel();
      }

      // 초기 상태 저장 (목표 불러오기 완료 후)
      _initialGoals = Map.from(_selectedGoals);
    } catch (e) {
      print('⚠️ User 정보에서 목표 불러오기 실패: $e');
      // Fallback: HomeViewModel에서 불러오기 시도
      _loadFromHomeViewModel();
      _initialGoals = Map.from(_selectedGoals);
    }
  }

  void _loadFromHomeViewModel() {
    try {
      final homeViewModel = Get.find<HomeViewModel>();
      final existingGoals = homeViewModel.goals;

      for (final goal in existingGoals) {
        _selectedGoals[goal.type] = goal.targetValue;
      }

      print('✅ HomeViewModel에서 목표 불러오기 완료: $_selectedGoals');
    } catch (e) {
      print('⚠️ HomeViewModel에서 목표 불러오기 실패: $e');
    }
  }

  GoalType? _apiStringToGoalType(String type) {
    switch (type) {
      case 'daily_problem':
        return GoalType.dailyProblem;
      case 'daily_accuracy':
        return GoalType.dailyAccuracy;
      case 'consecutive_study_days':
        return GoalType.consecutiveStudyDays;
      default:
        return null;
    }
  }

  bool isGoalTypeSelected(GoalType type) {
    return _selectedGoals.containsKey(type) && _selectedGoals[type]! > 0;
  }

  double getGoalValue(GoalType type) {
    return _selectedGoals[type] ?? 0.0;
  }

  void setGoalValue(GoalType type, double value) {
    if (value > 0) {
      _selectedGoals[type] = value;
    } else {
      _selectedGoals.remove(type);
    }
  }

  void removeGoal(GoalType type) {
    _selectedGoals.remove(type);
  }

  Future<void> saveGoals() async {
    try {
      // UserRepository를 통해 goal_table 저장
      final goalTable = <String, int>{};
      for (final entry in _selectedGoals.entries) {
        goalTable[_goalTypeToApiString(entry.key)] = entry.value.toInt();
      }
      final requestBody = {'goal_table': goalTable};
      print('📤 목표 저장 요청: $requestBody');
      final success = await _userRepository.updateUserInfo(requestBody);

      if (success) {
        _initialGoals = Map.from(_selectedGoals);
        print('✅ 목표 저장 완료');
      } else {
        print('⚠️ 목표 저장 실패');
        Get.snackbar('오류', '목표 저장에 실패했습니다.');
      }
    } catch (e) {
      print('⚠️ 목표 저장 중 오류 발생: $e');
      Get.snackbar('오류', '목표 저장 중 오류가 발생했습니다.');
    }
  }

  String _goalTypeToApiString(GoalType type) {
    switch (type) {
      case GoalType.dailyProblem:
        return 'daily_problem';
      case GoalType.dailyAccuracy:
        return 'daily_accuracy';
      case GoalType.consecutiveStudyDays:
        return 'consecutive_study_days';
    }
  }

  void refreshHomeGoals() {
    try {
      final homeViewModel = Get.find<HomeViewModel>();
      homeViewModel.loadAllGoalsProgress();
    } catch (e) {
      print('⚠️ HomeViewModel을 찾을 수 없습니다: $e');
    }
  }
}
