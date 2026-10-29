class ApiConstants {
  ApiConstants._();
  // Base Url
  static const String devBaseUrl =
      'https://6845b196fc51878754dc00b9.mockapi.io';
  static const String stagingBaseUrl =
      'https://6845b196fc51878754dc00b9.mockapi.io';
  static const String prodBaseUrl =
      'https://6845b196fc51878754dc00b9.mockapi.io';

  // Account
  static const String login = '/cskh/user/login';
  static const String refreshToken = '/auth/refresh';

  static const List<String> nonAuthenticatedPaths = [login, refreshToken];
}
