import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/start_up/create_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/translations/login.i18n.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/widgets/elements.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  final String routeName = 'SignUp';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool privacyPolicyAgree = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPress(context: context),
      child: Scaffold(
        backgroundColor: Color(0xFFFF6159),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: displayWidth(context) * 0.85,
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Wrap(
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: <Widget>[
                              verticalSpace(context, 0.015),
                              cardHeader(context: context, text: "Sign Up".i18n),
                              verticalSpace(context, 0.015),
                              inputForm(context: context, header: "Email".i18n, hint: "Enter your email".i18n, icon: Icons.email),
                              verticalSpace(context, 0.025),
                              inputForm(context: context, header: "Password".i18n, hint: "Enter a password".i18n, obscure: true, icon: Icons.vpn_key),
                              verticalSpace(context, 0.025),
                              inputForm(context: context, header: "Confirm Password".i18n, hint: "Reenter password".i18n, obscure: true, icon: Icons.vpn_key),
                              verticalSpace(context, 0.025),
                              inputForm(context: context, header: "Referral Code (optional)".i18n, hint: "Enter referral code".i18n, icon: Icons.group),
                              verticalSpace(context, 0.01),
                              privacyPolicyRow()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(context, 0.02),
                generalBlueButton(context: context, text: "Sign Up".i18n, function: () {navigate(context: context, page: CreateProfile(), direction: 'right', fromDrawer: false);}),
                verticalSpace(context, 0.03),
                orDivider(),
                verticalSpace(context, 0.02),
                Text("SIGN UP WITH".i18n,
                    style: GoogleFonts.notoSans(
                        fontSize: displayWidth(context) * 0.03,
                        fontWeight: FontWeight.w200,
                        letterSpacing: displayWidth(context) * 0.005,
                        color: Colors.white)),
                verticalSpace(context, 0.02),
                socialRow(context: context, function: () {}),
                verticalSpace(context, 0.03),
                contactUsRow(context: context, text1: "Having problems? ".i18n, text2: "Contact Us".i18n, function: () {})
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget orDivider() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Divider(
              indent: displayWidth(context) * 0.25,
              endIndent: displayWidth(context) * 0.04,
              color: Colors.white,
            )),
        Text("OR".i18n,
            style: GoogleFonts.notoSans(
                fontSize: displayWidth(context) * 0.025,
                fontWeight: FontWeight.w200,
                letterSpacing: displayWidth(context) * 0.005,
                color: Colors.white)),
        Expanded(
            child: Divider(
              indent: displayWidth(context) * 0.04,
              endIndent: displayWidth(context) * 0.25,
              color: Colors.white,
            )),
      ],
    );
  }

  Widget privacyPolicyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(value: privacyPolicyAgree,
        activeColor: Color(0xFFFF6159),
        checkColor: Colors.white,
        onChanged: (bool newValue) {setState(() {
          privacyPolicyAgree = newValue;
        });},),
        Text(
          "Agree to ".i18n,
          style: GoogleFonts.notoSans(
              color: Color(0xFFFF6159),
              fontSize: displayWidth(context) * 0.03,
        ),
        ),
        Text(
          "Privacy Policy".i18n,
          style: GoogleFonts.notoSans(
              color: Color(0xFFFF6159),
              fontSize: displayWidth(context) * 0.03,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
