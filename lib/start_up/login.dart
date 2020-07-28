import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/start_up/forgot_password.dart';
import 'package:fieldhand/central/dashboard.dart';
import 'package:fieldhand/start_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/translations/login.i18n.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/widgets/elements.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  final String routeName = 'Login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

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
                      borderRadius: BorderRadius.circular(displayWidth(context) * 0.08),
                    ),
                    child: Wrap(
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: <Widget>[
                              verticalSpace(context, 0.02),
                              cardHeader(context: context, text: "Sign In".i18n),
                              verticalSpace(context, 0.02),
                              inputForm(context: context, header: "Email".i18n, hint: "Enter your email".i18n, icon: Icons.email),
                              verticalSpace(context, 0.03),
                              inputForm(context: context, header: "Password".i18n, hint: "Enter your password".i18n, obscure: true, icon: Icons.vpn_key),
                              verticalSpace(context, 0.025),
                              forgotPasswordButton(),
                              verticalSpace(context, 0.02)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(context, 0.02),
                generalBlueButton(context: context, text: "Sign In".i18n, function: () {navigate(context: context, page: Dashboard(), direction: 'right', fromDrawer: false);}),
                verticalSpace(context, 0.03),
                orDivider(),
                verticalSpace(context, 0.03),
                Text("SIGN IN WITH".i18n,
                    style: GoogleFonts.notoSans(
                        fontSize: displayWidth(context) * 0.03,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 2.0,
                        color: Colors.white)),
                verticalSpace(context, 0.025),
                socialRow(context: context, function: () {}),
                verticalSpace(context, 0.06),
                signUpRow()
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


  Widget signUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Don't have an account? ".i18n,
            style: GoogleFonts.notoSans(
                fontSize: displayWidth(context) * 0.03,
                fontWeight: FontWeight.w200,
                letterSpacing: displayWidth(context) * 0.005,
                color: Colors.white)),
        GestureDetector(
          onTap: () {navigate(context: context, page: SignUp(), direction: 'right', fromDrawer: false);},
          child: Text("Sign Up".i18n,
              style: GoogleFonts.notoSans(
                  fontSize: displayWidth(context) * 0.033,
                  fontWeight: FontWeight.w800,
                  letterSpacing: displayWidth(context) * 0.005,
                  color: Colors.white)),
        ),
      ],
    );
  }

  Widget forgotPasswordButton() {
    return Padding(
      padding: EdgeInsets.only(right: displayWidth(context) * 0.05),
      child: Container(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {navigate(context: context, page: ForgotPassword(), direction: 'right', fromDrawer: false);},
          child: Text(
            "Forgot Password?".i18n,
            style: GoogleFonts.notoSans(
                color: Color(0xFFFF6159),
                fontSize: displayWidth(context) * 0.032,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

}
