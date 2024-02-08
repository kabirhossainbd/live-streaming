import 'package:get/get.dart';
import 'package:live_streaming/src/presentation/view/pages/authentication/login_screen.dart';
import 'package:live_streaming/src/presentation/view/pages/dashboard/start_screen.dart';
import 'package:live_streaming/src/presentation/view/pages/home/home_screen.dart';

class MyRouteHelper {
  static const String splashScreen = '/splash';
  static const String home = '/home';
  static const String loginScreen = '/loginScreen';
  static const String dashboard = '/';
  static const String successfulScreen = '/successful';
  static const String productDetails = '/product-branch';
  static const String searchResult = '/search-result';
  static const String searchScreen = '/search';
  static const String notification = '/notification';
  static const String favourite = '/favourite';
  static const String inboxScreen = '/inbox-screen';

  static String getSplashRoute() => splashScreen;
  static String getLoginRoute() => loginScreen;

  static String getMainRoute() => dashboard;

  static String getHomeRoute() => home;

  static List<GetPage> routes = [
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
  ];
}
