/// Central place for API base URL and endpoint paths.
///
/// IMPORTANT for local development with an emulator/device:
/// - Android emulator: use 'http://10.0.2.2:5000' (not localhost —
///   10.0.2.2 is the special alias the Android emulator uses to reach
///   your host machine's localhost).
/// - iOS simulator: 'http://localhost:5000' works fine.
/// - Physical device: use your computer's local network IP, e.g.
///   'http://192.168.1.5:5000' (both phone and computer must be on
///   the same Wi-Fi network).
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://10.0.2.2:5000/api';

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';

  static const String categories = '/categories';
  static String categoryItems(String id) => '/categories/$id/items';

  static const String restaurants = '/restaurants';
  static String restaurantById(String id) => '/restaurants/$id';
  static String restaurantMenu(String id) => '/restaurants/$id/menu';
}
