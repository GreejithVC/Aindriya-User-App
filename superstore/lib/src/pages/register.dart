import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:superstore/generated/l10n.dart';
import 'package:superstore/src/repository/settings_repository.dart';
import '../controllers/user_controller.dart';
import 'dart:math';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends StateMVC<Register>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool isValidOtp = false;
  bool isOtpSend = false;
  bool autoValidate = false;
  UserController _con;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  _RegisterState() : super(UserController()) {
    _con = controller;
  }

  void initState() {
    super.initState();

    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 10),
    );

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _con.scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/loginbg1.jpg'),
                    fit: BoxFit.cover)),
          ),
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.transparent,
              Colors.transparent,
              Color(0xff161d27).withOpacity(0.9),
              Color(0xff161d27),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          Positioned(
            top: 50.0,
            right: size.width * -0.24,
            child: Container(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: animationController,
                child: Container(
                  child: Image(
                    image: AssetImage('assets/img/plate-food2.png'),
                    height: size.width * 0.5,
                    fit: BoxFit.fill,
                  ),
                ),
                builder: (BuildContext context, Widget _widget) {
                  return Transform.rotate(
                    angle: animationController.value * 2 * pi,
                    child: _widget,
                  );
                },
              ),
            ),
          ),
          Form(
            key: _con.loginFormKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).welcome,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("to ${setting.value.appName}, let's Login in",
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .merge(TextStyle(color: Colors.grey))),
                        SizedBox(
                          height: 10,
                        ),
                        AbsorbPointer(
                          absorbing: isOtpSend == true,
                          child: Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              width: double.infinity,
                              child: TextFormField(
                                  autovalidate: autoValidate == true,
                                  controller: _phoneNumberController,
                                  maxLength: 10,
                                  textAlign: TextAlign.left,
                                  autocorrect: true,
                                  onSaved: (input) =>
                                      _con.register_data.phone = input,
                                  validator: (input) {
                                    return _con.isValidMobileNumber(
                                        context, input);
                                  },
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorLight)),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    prefixText: "+91 ",
                                    prefixStyle: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        .merge(TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorLight)),
                                    labelText: S.of(context).mobile,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .merge(TextStyle(color: Colors.grey)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.0,
                                      ),
                                    ),
                                  ))),
                        ),
                        Visibility(
                          visible: isOtpSend == true && isValidOtp == false,
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 40, right: 40,top: 20),
                            child: PinInputTextField(
                              pinLength: 6,
                              decoration: BoxLooseDecoration(
                                  strokeColorBuilder: PinListenColorBuilder(
                                    Colors.grey,
                                    Colors.grey,
                                     ),
                                  bgColorBuilder: PinListenColorBuilder(
                                    Colors.white,
                                    Colors.white,
                                     ),
                                  radius: const Radius.circular(15),
                                  gapSpace: 20),
                              controller: _otpController,
                              textInputAction: TextInputAction.go,
                              enabled: true,
                              keyboardType: TextInputType.number,
                              onChanged: (pin) {
                                debugPrint('onChanged execute. pin:$pin');
                              },
                              enableInteractiveSelection: false,
                              cursor: Cursor(
                                width: 2,
                                color: Colors.yellowAccent,
                                enabled: true,
                              ),
                            ),
                          ),

                          // Container(
                          //   margin:
                          //       EdgeInsets.only(left: 34, right: 34, top: 20),
                          //   width: double.infinity,
                          //   child:
                          //   OTPTextField(
                          //     otpFieldStyle: OtpFieldStyle(
                          //         enabledBorderColor:
                          //             Theme.of(context).accentColor),
                          //     length: 6,
                          //     width: MediaQuery.of(context).size.width,
                          //     textFieldAlignment: MainAxisAlignment.spaceAround,
                          //     fieldWidth: 40,
                          //     style: TextStyle(
                          //         fontSize: 20,
                          //         color: Theme.of(context).primaryColorLight),
                          //     fieldStyle: FieldStyle.underline,
                          //
                          //     onCompleted: (pin) {},
                          //   ),
                          // ),
                        ),
                        Visibility(
                          visible: isValidOtp == true,
                          child: Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              width: double.infinity,
                              child: TextFormField(
                                  textAlign: TextAlign.left,
                                  autocorrect: true,
                                  onSaved: (input) =>
                                      _con.register_data.name = input,
                                  validator: (input) => input.length < 3
                                      ? S
                                          .of(context)
                                          .should_be_more_than_3_characters
                                      : null,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorLight)),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).full_name,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .merge(TextStyle(color: Colors.grey)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.0,
                                      ),
                                    ),
                                  ))),
                        ),
                        Visibility(
                          visible: isValidOtp == true,
                          child: Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              width: double.infinity,
                              child: TextFormField(
                                  textAlign: TextAlign.left,
                                  autocorrect: true,
                                  onSaved: (input) =>
                                      _con.register_data.email_id = input,
                                  validator: (input) => !input.contains('@')
                                      ? S.of(context).invalid_email_format
                                      : null,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorLight)),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).email,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .merge(TextStyle(color: Colors.grey)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.0,
                                      ),
                                    ),
                                  ))),
                        ),
                        Visibility(
                          visible: isValidOtp == true,
                          child: Container(
                              margin: EdgeInsets.only(left: 40, right: 40),
                              width: double.infinity,
                              child: TextFormField(
                                  textAlign: TextAlign.left,
                                  autocorrect: true,
                                  onSaved: (input) =>
                                      _con.register_data.password = input,
                                  validator: (input) => input.length < 3
                                      ? S
                                          .of(context)
                                          .should_be_more_than_3_characters
                                      : null,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorLight)),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).password,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .merge(TextStyle(color: Colors.grey)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.0,
                                      ),
                                    ),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: isValidOtp == false && isOtpSend == false,
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 40, right: 40),
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              onPressed: () {
                                if (_con.isValidMobileNumber(context,
                                        _phoneNumberController.text.trim()) ==
                                    null) {
                                  setState(() {
                                    isOtpSend = true;
                                    autoValidate = true;
                                  });
                                } else {
                                  setState(() {
                                    autoValidate = true;
                                  });
                                }
                              },
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text("Send OTP",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .merge(TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isOtpSend == true && isValidOtp == false,
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 40, right: 40),
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              onPressed: () {
                                if (_otpController.text.trim().isEmpty == true) {
                                  showSnackBar(context, "Please enter OTP");
                                } else if (_otpController.text.trim().length == 6){
                                  showSnackBar(context, "Successfully");
                                  setState(() {
                                    isValidOtp = true;
                                  });
                                }
                                else {
                                  showSnackBar(context, "Invalid OTP");
                                }
                                // _con.validateOTPAndVerify(context,
                                //     enteredOTP: _otpController.text.trim(),
                                // contact: _phoneNumberController.text.trim(),);
                                // setState(() {
                                //   isValidOtp = true;
                                // });
                              },
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text("Verify OTP",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .merge(TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isValidOtp == true,
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 40, right: 40),
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              onPressed: () {
                                _con.register();
                              },
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(S.of(context).register,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .merge(TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${S.of(context).already_have_an_account} ?",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/Login');
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ]))
                ],
              ),
            ),
          ),
        ],
      ),
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
}
