import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:rest_test/provider/auth/auth_provider.dart';
import 'package:rest_test/provider/auth/auth_provider_impl.dart';
import 'package:rest_test/provider/test/test_provider.dart';
import 'package:rest_test/provider/test/test_provider_impl.dart';
import 'package:rest_test/repository/test/test_repository.dart';
import 'package:rest_test/repository/test/test_repository_impl.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut<AuthProvider>(() => AuthProviderImpl());
    Get.lazyPut<TestProvider>(() => TestProviderImpl());

    // Respositorys
    Get.lazyPut<TestRepository>(() => TestRepositoryImpl());
  }
}
