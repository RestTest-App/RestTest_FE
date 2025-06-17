import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:rest_test/provider/auth/auth_provider.dart';
import 'package:rest_test/provider/auth/auth_provider_impl.dart';
import 'package:rest_test/provider/user/user_provider.dart';
import 'package:rest_test/provider/user/user_provider_impl.dart';
import 'package:rest_test/repository/user/user_repository.dart';
import 'package:rest_test/repository/user/user_repository_impl.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut<AuthProvider>(() => AuthProviderImpl());
    Get.lazyPut<UserProvider>(() => UserProviderImpl());
    Get.lazyPut<UserRepository>(
        () => UserRepositoryImpl(Get.find<UserProvider>()));
  }
}
