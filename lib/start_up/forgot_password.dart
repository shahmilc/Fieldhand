import 'package:fieldhand/computation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/translations/login.i18n.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  final String routeName = 'ForgotPassword';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPress(context: context),
      child: Scaffold(
        backgroundColor: Color(0xFFFF6159),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: displayHeight(context) * 0.25,
                width: displayWidth(context) * 0.85,
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(displayWidth(context) * 0.08),
                  ),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        verticalSpace(context, 0.03),
                        cardHeader(context: context, text: "Reset Password".i18n),
                        verticalSpace(context, 0.02),
                        inputForm(context: context, header: "Email".i18n, hint: "Enter your email".i18n, icon: Icons.email),
                      ],
                    ),
                  ),
                ),
              ),
              verticalSpace(context, 0.02),
              generalBlueButton(context: context, text: "Send Email".i18n, function: () {}),
              verticalSpace(context, 0.06),
              contactUsRow(context: context, text1: "Having problems? ".i18n, text2: "Contact Us".i18n, function: () {})
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

}