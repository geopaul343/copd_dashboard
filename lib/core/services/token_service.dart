class TokenService {
  static String? _accessToken;

  // Set the access token
  static void setAccessToken(String token) {
    _accessToken = token;
    print('Access token set: $token');
  }

  // Get the access token
  static String? getAccessToken() {
    return _accessToken;
  }

  // Clear the access token
  static void clearAccessToken() {
    _accessToken = null;
    print('Access token cleared');
  }

  // Check if token exists
  static bool hasToken() {
    return _accessToken != null;
  }
}
