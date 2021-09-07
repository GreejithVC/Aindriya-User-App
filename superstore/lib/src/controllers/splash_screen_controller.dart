import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:superstore/src/repository/settings_repository.dart';
import '../helpers/custom_trace.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/settings_repository.dart' as settingRepo;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
class SplashScreenController extends ControllerMVC {
  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());
  GlobalKey<ScaffoldState> scaffoldKey;
  //final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  SplashScreenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    // Should define these variables before the app loaded
    progress.value = {"Setting": 0, "User": 0};
  }

  @override
  void initState() {
    super.initState();
   // firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));



   /** FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
       /** Navigator.pushNamed(context, '/message',
            arguments: MessageArguments(message, true)); */
      }
    }); */


    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,

            NotificationDetails(
              android: AndroidNotificationDetails(
                'your channel id',
                setting.value.appName,
                'your channel description',
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@mipmap/ic_launcher',
                importance: Importance.max,
                enableVibration: true,

                
                priority: Priority.high,
                ongoing: true,
                  autoCancel: false,

              ),

            ), payload: 'item x');
      }


    });



    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    /**  Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true)); */
    });

    settingRepo.setting.addListener(() {
      progress.value["Setting"] = 41;
      progress.value["User"] = 59;
      print('success');
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      progress?.notifyListeners();
    });

    Timer(Duration(seconds: 20), () {
      // ignore: deprecated_member_use
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Verify your internet'),
      ));
    });
  }



  void configureFirebase(FirebaseMessaging _firebaseMessaging) {
    try {
      /**_firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");

        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      ); */
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
      print(CustomTrace(StackTrace.current, message: 'Error Config Firebase'));
    }
  }
}
