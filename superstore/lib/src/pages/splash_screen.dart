import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController _con;
  bool firstLoad = false;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      loadData();
    });

  }

  void loadData() {
    _con.progress.addListener(() {
      double progress = 0;
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;
        print(progress);
      });
      if (progress == 100) {
        try {
          print('loader');

          if (currentUser.value.auth != false &&
              currentUser.value.auth != null) {
            if (currentUser.value.latitude != 0.0 &&
                currentUser.value.longitude != 0.0) {
              if (firstLoad == false) {
                setState(() {
                  firstLoad = true;
                });
                Navigator.of(context)
                    .pushReplacementNamed('/Pages', arguments: 2);
              }
            } else {
              Navigator.of(context).pushReplacementNamed('/location');
            }
          } else {
            Navigator.of(context).pushReplacementNamed('/introscreen');
          }
        } catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      key: _con.scaffoldKey,
      body: 1 == 1
          ? Container(
              padding: EdgeInsets.only(
                top: 0,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 200),
                  Image.asset(
                    'assets/img/logo.png',
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 50),
                  SpinKitThreeBounce(
                    color: const Color(0xff1169BF),
                    // type: SpinKitWaveType.start,
                    size: 50.0,
                  ),

                  // SpinKitWave(
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return DecoratedBox(
                  //       decoration: BoxDecoration(
                  //         color: index.isEven ? Colors.white : Colors.green,
                  //       ),
                  //     );
                  //   },
                  // )
                  // Expanded(
                  //   child: FlareActor(
                  //     "assets/img/splash.flr",
                  //     alignment: Alignment.center,
                  //     fit: BoxFit.cover,
                  //     animation: "bottomanimi",
                  //   ),
                  // ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/img/logo.png',
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 50),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
