import 'dio_client.dart';
import 'share_preference.dart';
import 'secure_storage.dart';

class Services {
  Services(this.dio, this.sharedPreference, this.secureStorage);

  final DioClient dio;
  final SharePreference sharedPreference;
  final SecureStorage secureStorage;
}
