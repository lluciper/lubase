import 'api/dio_client.dart';
import 'storage/share_preference.dart';
import 'storage/secure_storage.dart';

class Services {
  Services(this.dio, this.sharedPreference, this.secureStorage);

  final DioClient dio;
  final SharePreference sharedPreference;
  final SecureStorage secureStorage;
}
