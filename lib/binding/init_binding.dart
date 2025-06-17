import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:rest_test/provider/auth/auth_provider.dart';
import 'package:rest_test/provider/auth/auth_provider_impl.dart';
import 'package:rest_test/provider/book/book_provider.dart';
import 'package:rest_test/provider/book/book_provider_impl.dart';
import 'package:rest_test/provider/test/test_provider.dart';
import 'package:rest_test/provider/test/test_provider_impl.dart';
import 'package:rest_test/provider/today/today_provider.dart';
import 'package:rest_test/provider/today/today_provider_impl.dart';
import 'package:rest_test/repository/book/book_repository.dart';
import 'package:rest_test/repository/book/book_repository_impl.dart';
import 'package:rest_test/repository/test/test_repository.dart';
import 'package:rest_test/repository/test/test_repository_impl.dart';
import 'package:rest_test/repository/today/today_repository.dart';
import 'package:rest_test/repository/today/today_repository_impl.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut<AuthProvider>(() => AuthProviderImpl());
    Get.lazyPut<TestProvider>(() => TestProviderImpl());
    Get.lazyPut<BookProvider>(()=> BookProviderImpl());
    Get.lazyPut<TodayProvider>(() => TodayProviderImpl());
    // Respositorys
    Get.lazyPut<TestRepository>(() => TestRepositoryImpl());
    Get.lazyPut<BookRepository>(() => BookRepositoryImpl());
    Get.lazyPut<TodayRepository>(() => TodayRepositoryImpl());
  }
}
