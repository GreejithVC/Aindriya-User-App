import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'src/controllers/initial_controller.dart';
import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/custom_trace.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;
import 'src/repository/product_repository.dart' as proRepo;
import 'package:firebase_core/firebase_core.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GlobalConfiguration().loadFromAsset("configurations");
  // ignore: deprecated_member_use
  print(CustomTrace(StackTrace.current, message: "base_url: ${GlobalConfiguration().getString('base_url')}"));
  // ignore: deprecated_member_use
  print(CustomTrace(StackTrace.current, message: "api_base_url: ${GlobalConfiguration().getString('api_base_url')}"));
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
//  /// Supply 'the Controller' for this application.
//  MyApp({Key key}) : super(con: Controller(), key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends StateMVC<MyApp> {
  InitialController  _con;
  _MyAppState() : super(InitialController()) {
    _con = controller;
  }

  @override
  void initState() {
    settingRepo.initSettings();
    userRepo.getCurrentUser();
    proRepo.getCurrentCartItem();
    proRepo.getCurrentCheckout();
    _con.listenForTips();
    _con.listenForLogisticsPricing();
   // homeCon.listenForTips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          return MaterialApp(
              navigatorKey: settingRepo.navigatorKey,
              title: _setting.appName,
              initialRoute: '/Splash',
              onGenerateRoute: RouteGenerator.generateRoute,
              debugShowCheckedModeBanner: false,
              locale: _setting.mobileLanguage.value,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: _setting.brightness.value == Brightness.light
                  ? ThemeData(
                      fontFamily: 'proximanova-regular',
                      primaryColor: Colors.white,
                      disabledColor: Colors.grey,
                      cardColor: Colors.lightBlue[50],
                      secondaryHeaderColor: Color(0xFF047BD5).withOpacity(1.0),
                      floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
                      brightness: Brightness.light,

                      primaryColorLight: Colors.white,
                      backgroundColor: Colors.black,
                      //accentColor: Color(0xFFFc8019),
                      accentColor: Color(0xFFfbbc00).withOpacity(1.0),
                      dividerColor: Color(0xFF8c98a8).withOpacity(0.1),
                      focusColor: Color(0xFF8c98a8).withOpacity(1.0),
                      primaryColorDark:  Color(0xFFfbbc00),
                      textTheme: TextTheme(
                        headline5: TextStyle(fontSize: 22.0, color: Color(0xFF043832).withOpacity(1.0), height: 1.3),
                        headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Color(0xFF043832).withOpacity(1.0), height: 1.3),
                        headline3: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700, color: Color(0xFF043832).withOpacity(1.0), height: 1.3),
                        headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color:  Color(0xFFfbbc00).withOpacity(1.0), height: 1.4),
                        headline1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Color(0xFF043832).withOpacity(1.0), height: 1.4),
                        subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: Colors.black, height: 1.3),
                        subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Color(0xFF043832).withOpacity(1.0), height: 1.2),
                        headline6: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color:  Color(0xFFfbbc00).withOpacity(1.0), height: 1.3),
                        bodyText2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: Colors.black, height: 1.2),
                        bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Color(0xFF043832).withOpacity(1.0), height: 1.3),
                        caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: Color(0xFF8c98a8).withOpacity(1.0), height: 1.7),
                      ),
                    )
                  : ThemeData(
                      fontFamily: 'proximanova-regular',
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor: Color(0xFF2C2C2C),
                      primaryColorLight: Colors.white,
                      //accentColor: Color(0xFFfbbc00),047BD5
                      accentColor: Color(0xFFfbbc00).withOpacity(1.0),
                      dividerColor: Color(0xFF9999aa).withOpacity(0.1),
                      hintColor: Color(0xFFccccdd).withOpacity(0.1),
                      focusColor: Color(0xFF9999aa).withOpacity(1),
                      backgroundColor: Colors.white,

                      textTheme: TextTheme(
                        headline5: TextStyle(fontSize: 22.0, color: Color(0xFF9999aa).withOpacity(1), height: 1.3),
                        headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Color(0xFF9999aa).withOpacity(1), height: 1.3),
                        headline3: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700, color: Color(0xFF9999aa).withOpacity(1), height: 1.3),
                        headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: Color(0xFFfbbc00).withOpacity(1.0), height: 1.4),
                        headline1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Color(0xFFffffff).withOpacity(1), height: 1.4),
                        subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: Color(0xFF9999aa).withOpacity(1), height: 1.3),
                        subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Color(0xFF9999aa).withOpacity(1), height: 1.2),
                        headline6: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: Color(0xFFfbbc00).withOpacity(1.0), height: 1.3),
                        bodyText2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: Color(0xFF9999aa).withOpacity(1), height: 1.2),
                        bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Color(0xFF9999aa).withOpacity(1), height: 1.3),
                        caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Color(0xFF9999aa).withOpacity(0.6), height: 1.2),
                      ),
                    ));
        });
  }
}
