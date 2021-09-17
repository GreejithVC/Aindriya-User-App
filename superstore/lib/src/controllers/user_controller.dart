import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superstore/src/models/address.dart';
import 'package:toast/toast.dart';

import '../models/registermodel.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;
import '../repository/user_repository.dart';
import '../../generated/l10n.dart';

class UserController extends ControllerMVC {
  UserDetails user = new UserDetails();
  bool hidePassword = true;
  Address addressData = Address();
  bool loading = false;
  bool autoValidate = false;
  String otpNumber;

  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKeyState;

  OverlayEntry loader;

  // ignore: non_constant_identifier_names
  Registermodel register_data = new Registermodel();

  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.scaffoldKeyState = new GlobalKey<ScaffoldState>();
    //_firebaseMessaging = FirebaseMessaging();

    //  listenForAddress();
  }

  void login() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.login(user).then((value) {
        Helper.hideLoader(loader);
        if (value != null && value.apiToken != null) {
          /**  Fluttertoast.showToast(
              msg: "${S.of(context).login} ${S.of(context).successfully}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              ); */
          //   gettoken();

          if (currentUser.value.latitude != 0.0 &&
              currentUser.value.longitude != 0.0) {
            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
          } else {
            Navigator.of(context).pushReplacementNamed('/location');
          }
        } else {
          // ignore: deprecated_member_use
          scaffoldKeyState?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        // ignore: deprecated_member_use
        scaffoldKeyState?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_account_not_exist),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  gettoken() {
    FirebaseMessaging.instance.getToken().then((deviceid) {
      print(deviceid);
      var table = 'user' + currentUser.value.id;
      FirebaseFirestore.instance.collection('devToken').doc(table).set({
        'devToken': deviceid,
        'userId': currentUser.value.id
      }).catchError((e) {
        print('firebase error');
        print(e);
      });
    });
  }

  void saveAddress() {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();

      setState(() => currentUser.value.address.add(addressData));
      setCurrentUserUpdate(currentUser.value);
      Navigator.pop(context);
    }
  }

  void register() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.register(register_data).then((value) {
        print(value);
        if (value == true) {
          showToast("${S.of(context).register} ${S.of(context).successfully}",
              gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
          Navigator.of(context).pushReplacementNamed('/Login');
        } else {
          // ignore: deprecated_member_use
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).this_email_account_exists),
          ));
        }
      }).catchError((e) {
        loader.remove();
        // ignore: deprecated_member_use
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_email_account_exists),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void resetPassword() {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          // ignore: deprecated_member_use
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content:
                Text(S.of(context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext)
                    .pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          // ignore: deprecated_member_use
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).error_verify_email_settings),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(
      msg,
      context,
      duration: duration,
      gravity: gravity,
    );
  }

  // void validateAndSendOTP(
  //   BuildContext context, {
  //   String contact,
  // }) async {
  //   if (isValidMobileNumber(context, contact) == null) {
  //     sendOtp(contact);
  //   }
  // }

  String isValidMobileNumber(BuildContext context, String input) {
    if (input.length != 10) {
      return S.of(context).invalid_mobile_number;
    } else {
      return null;
    }
  }

  void sendOtp(String contact,Function setData) async {
    print("sendOtp hhhhhhhhhhhh");
    print("sendOtp to");
    print(contact);
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneCodeSent codeSent = (String verificationID, int resendToken) {
      showSnackBar(context, "verification code has been send to your number");
      setData(verificationID);
      print("codeSent");
    };

    await auth.verifyPhoneNumber(
      phoneNumber: "+91$contact", timeout: Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("verificationCompleted");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("verificationFailed");
        print(e.message);
      },
      codeSent: codeSent,
      //     (String verificationId, int resendToken) async {
      //   print("codeSent");
      //   String smsCode = 'xxxxxx';
      //
      //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //       verificationId: verificationId, smsCode: smsCode);
      //
      //   await auth.signInWithCredential(credential);
      //   print("Phone number automatically verified and user signed in: ${auth.currentUser.uid}");
      // },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout");
        verificationId = verificationId;
        print(verificationId);
        print("Timout");
      },
    );
  }

  // void validateOTPAndVerify(BuildContext context,
  //     { String enteredOTP,
  //
  //      }) async {
  //   if (enteredOTP.isEmpty == true) {
  //     showSnackBar(context, "Please enter OTP");
  //   } else if (enteredOTP.length == 6) {
  //     verifyOTP(context,
  //
  //       enteredOTP: enteredOTP,
  //        );
  //   } else {
  //     showSnackBar(context, "Invalid OTP");
  //   }
  // }

  Future<void> verifyOTP(
    BuildContext context, {
    String enteredOTP,
  }) async {
    print(enteredOTP);
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      // verificationCompleted: (PhoneAuthCredential credential) async {
      //   print("verificationCompleted");
      // },
      // verificationFailed: (FirebaseAuthException e) {
      //   print("verificationFailed");
      //   print(e.message);
      // },
      codeSent: (String verificationId, int resendToken) async {
        print("codeRecived");
        print(enteredOTP);
        String smsCode = enteredOTP;

        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        await auth.signInWithCredential(credential);
        print("Phone number verified : ${auth.currentUser.uid}");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout");
        verificationId = verificationId;
        print(verificationId);
        print("Timout");
      },
    );
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? ""),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> verifyPhoneNumber(
      BuildContext context, Function setData, String contact) async {
    print("verifyPhoneNumber");

    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "verificationCompleted");
      print("verificationCompleted");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) async {
      showSnackBar(context, exception.toString());
      print("verificationFailed");
    };
    PhoneCodeSent codeSent = (String verificationID, int resendToken) {
      showSnackBar(context, "verification code has been send to your number");
      setData(verificationID);
      print("codeSent");
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time Out");
      print("Time Out");
    };

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: "+91$contact",
        timeout: Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    print("smscode");
    print(smsCode);
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =  await auth.signInWithCredential(credential);
      print("Phone number automatically verified and user signed in: ${auth.currentUser.uid}");
      print("Phone number automatically verified and user signed in: $userCredential");
    } catch (e) {}
  }
}
