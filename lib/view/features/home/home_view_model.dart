import '../../../core/index.dart';

class HomeViewModel extends BaseViewModel<void> {
  HomeViewModel() : super(null);

  /// No navigation here: the router leaves Home once the session ends.
  Future<void> logout() => repository.auth.logout();
}
