import 'package:get/get.dart';
import 'package:rest_test/viewmodel/auth/auth_view_model.dart';
import 'package:rest_test/viewmodel/mypage/mypage_view_model.dart';
import 'package:rest_test/viewmodel/onboarding/onboarding_view_model.dart';
import 'package:rest_test/viewmodel/review/review_view_model.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:rest_test/viewmodel/home/home_view_model.dart';
import 'package:rest_test/viewmodel/root/root_view_model.dart';
import 'package:rest_test/viewmodel/today/today_test_view_model.dart';
import 'package:rest_test/viewmodel/goal/goal_setting_view_model.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootViewModel>(() => RootViewModel(), fenix: true);

    HomeBinding().dependencies();
    ReviewBinding().dependencies();
    BookBinding().dependencies();
    MyPageBinding().dependencies();
    TestBinding().dependencies();
    TestExamBinding().dependencies();
    TestResultBinding().dependencies();
    TestCommentBinding().dependencies();
    OnboardingBinding().dependencies();
    ReviewContentBinding().dependencies();
    TodayTestBinding().dependencies();
    TodayTestExamBinding().dependencies();
    TodayTestCommentBinding().dependencies();
    GoalSettingBinding().dependencies();
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeViewModel>(() => HomeViewModel());
  }
}

class ReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewViewModel>(() => ReviewViewModel());
  }
}

class ReviewContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewViewModel>(() => ReviewViewModel());
  }
}

class BookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookViewModel>(() => BookViewModel());
  }
}

class MyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPageViewModel>(() => MyPageViewModel());
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthViewModel>(() => AuthViewModel());
  }
}

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingViewModel>(() => OnboardingViewModel());
  }
}

class TestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestViewModel>(() => TestViewModel());
  }
}

class TestExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestViewModel>(() => TestViewModel());
  }
}

class TestResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestViewModel>(() => TestViewModel());
  }
}

class TestCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestViewModel>(() => TestViewModel());
  }
}

class TodayTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodayTestViewModel>(() => TodayTestViewModel());
  }
}

class TodayTestExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodayTestViewModel>(() => TodayTestViewModel());
  }
}

class TodayTestCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodayTestViewModel>(() => TodayTestViewModel());
  }
}

class GoalSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalSettingViewModel>(() => GoalSettingViewModel());
  }
}
