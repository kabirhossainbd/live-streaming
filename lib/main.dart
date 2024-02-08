import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_streaming/controller/auth_controller.dart';
import 'package:live_streaming/controller/language_controller.dart';
import 'package:live_streaming/controller/localization_controller.dart';
import 'package:live_streaming/controller/theme_controller.dart';
import 'package:live_streaming/services/local_string.dart';
import 'package:live_streaming/src/config/routes/route_helper.dart';
import 'package:live_streaming/src/config/themes/dark_theme.dart';
import 'package:live_streaming/src/config/themes/light_theme.dart';
import 'package:live_streaming/src/config/themes/m_theme_util.dart';
import 'package:live_streaming/src/data/datasource/local/database_repository.dart';
import 'package:live_streaming/src/utils/constants/m_key.dart';
import 'package:live_streaming/src/utils/constants/m_strings.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'src/locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  ThemeUtil.allScreenTheme();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await Future.delayed(const Duration(milliseconds: 300));



  await di.init();
  Map<String, Map<String, String>> localString = await di.init();
  runApp(MyApp(
    localString: localString,
  ));
}

class MyApp extends StatefulWidget{
  static final navigatorKey = GlobalKey<NavigatorState>();
  final Map<String, Map<String, String>> localString;
  const MyApp({Key? key, required this.localString}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  @override
  void initState() {
     super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @mustCallSuper
  @protected
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('----------->>> resumed');
        break;
      case AppLifecycleState.inactive:
        debugPrint('----------->>> Inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('----------->>> Paused');
        break;
      case AppLifecycleState.detached:
        debugPrint('----------->>> Detached');
        break;
      case AppLifecycleState.hidden:
        debugPrint('----------->>> hidden');
        // TODO: Handle this case.
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Theme.of(context).colorScheme.background,
      useDefaultLoading: false,
      child: ScreenUtilInit(
        builder: (_, child) => GetBuilder<ThemeController>(builder: (theme) {
          return GetBuilder<LocalizationController>(builder: (local) {
            return GetMaterialApp(
              locale: getLocal(context),
              translations: LocaleString(localString: widget.localString),
              fallbackLocale: const Locale('en', 'US'),
              title: MyStrings.appName,
              initialRoute: Get.find<AuthController>().isLoggedIn() ? MyRouteHelper.dashboard : MyRouteHelper.loginScreen,
              defaultTransition: Transition.topLevel,
              transitionDuration: const Duration(milliseconds: 500),
              getPages: MyRouteHelper.routes,
              navigatorKey: Get.key,
              theme: theme.darkTheme ? dark : light,
              debugShowCheckedModeBanner: false,
            );
          });
        }),
      ),
    );
  }
}



Locale getLocal(BuildContext context) {
  Locale currentLocale = View.of(context).platformDispatcher.locale;
  if (Get.find<LanguageController>().deviceLanguage) {
    Get.find<LanguageController>().setSelectIndex(0);
    if (currentLocale.countryCode == "BD") {
      currentLocale = Locale(
        MyKey.languages[1].languageCode!,
        MyKey.languages[1].countryCode,
      );
    } else {
      currentLocale = Locale(
        MyKey.languages[0].languageCode!,
        MyKey.languages[0].countryCode,
      );
    }
  } else {
    if (Get.find<LocalizationController>().locale.languageCode == 'en') {
      Get.find<LanguageController>().setSelectIndex(1);
      currentLocale = Locale(
        MyKey.languages[0].languageCode!,
        MyKey.languages[0].countryCode,
      );
    } else if (Get.find<LocalizationController>().locale.languageCode == 'bd') {
      Get.find<LanguageController>().setSelectIndex(2);
      currentLocale = Locale(
        MyKey.languages[1].languageCode!,
        MyKey.languages[1].countryCode,
      );
    }
  }
  return currentLocale;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
