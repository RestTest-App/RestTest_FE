import 'package:get/get.dart';

import '../viewmodel/root/root_view_model.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootViewModel>(() => RootViewModel(), fenix: true);

    // HomeBinding().dependencies();
    // ChattingListBinding().dependencies();
    // StatisticsBinding().dependencies();
    // StatisticsDetailBinding().dependencies();
    // ChattingRoomBinding().dependencies();
    // SeeMoreBinding().dependencies();
    // OnboardingBinding().dependencies();
    // LoginBinding().dependencies();
    // RegisterBinding().dependencies();
    // EndingBinding().dependencies();
  }
}

// class HomeBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<HomeViewModel>(() => HomeViewModel());
//   }
// }}