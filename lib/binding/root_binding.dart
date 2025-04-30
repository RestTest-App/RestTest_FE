import 'package:get/get.dart';
import 'package:rest_test/viewmodel/mypage/mypage_view_model.dart';
import 'package:rest_test/viewmodel/review/review_view_model.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';

import '../viewmodel/book/book_view_model.dart';
import '../viewmodel/home/home_view_model.dart';
import '../viewmodel/root/root_view_model.dart';

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
    // SeeMoreBinding().dependencies();
    // OnboardingBinding().dependencies();
    // LoginBinding().dependencies();
    // RegisterBinding().dependencies();
    // EndingBinding().dependencies();
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