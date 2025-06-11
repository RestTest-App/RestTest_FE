import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../provider/token/token_provider.dart';
import '../../provider/token/token_provider_impl.dart';

class SecureStorageFactory {
  static FlutterSecureStorage? _instance;

  static TokenProvider? _tokenProvider;
  static TokenProvider get tokenProvider => _tokenProvider!;

  Future<void> onInit() async {
    _instance = const FlutterSecureStorage();

    _tokenProvider = TokenProviderImpl(flutterSecureStorage: _instance!);

    await _tokenProvider!.onInit();
  }
}