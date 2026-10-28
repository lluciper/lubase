import '../services/services.dart';
import 'auth_repository.dart';
import 'demo_auth_repository.dart';

/// One field per domain repository (`repository.auth`, …); in `getIt`.
class Repository {
  /// [demoLogin]: log in without a backend (development, see DemoAuthRepository).
  Repository(Services services, {bool demoLogin = false})
    : auth = demoLogin
          ? DemoAuthRepository(services)
          : AuthRepository(services);

  final AuthRepository auth;
}
