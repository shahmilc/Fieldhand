import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/computation/screen_router.dart';
import 'package:fieldhand/database/firebase_core.dart';
import 'package:fieldhand/start_up/create_profile.dart';
import 'package:fieldhand/start_up/farm/farm_selection.dart';
import 'package:fieldhand/start_up/forgot_password.dart';
import 'package:fieldhand/central/dashboard.dart';
import 'package:fieldhand/start_up/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/translations/login.i18n.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/alert_dialogs.dart';
import 'package:fieldhand/connectivity/auth_connection.dart';
import 'package:fieldhand/computation/general_functions.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  final String routeName = 'Login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool _checking = false;

  TextEditingController _emailInput = TextEditingController();
  TextEditingController _passwordInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPress(context: context),
      child: Scaffold(
        backgroundColor: primaryRed(),
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
                              headerText(context: context, text: "Sign In".i18n),
                              verticalSpace(context, 0.02),
                              inputForm(context: context, header: "Email".i18n, hint: "Enter your email".i18n, icon: Icons.email, editingController: _emailInput, autoFillHints: [AutofillHints.email]),
                              verticalSpace(context, 0.03),
                              inputForm(context: context, header: "Password".i18n, hint: "Enter your password".i18n, obscure: true, icon: Icons.vpn_key, editingController: _passwordInput, autoFillHints: [AutofillHints.password]),
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
                generalBlueButton(context: context, text: "Sign In".i18n, disabled: _checking, loading: _checking, function: () {signInCheck();}),
                verticalSpace(context, 0.03),
                textDivider(context: context, text: "OR".i18n, color: Colors.white),
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

  @override
  void dispose() {
    _emailInput.dispose();
    _passwordInput.dispose();
    super.dispose();
  }

  signInCheck() async {
    setState(() {
      _checking = true;
    });

    if (RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(_emailInput.text.trim())) {
      if (RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$").hasMatch(_passwordInput.text.trim())) {
        try {
          bool _success = await FirebaseAuthorization().signInWithEmailAndPassword(email: _emailInput.text.trim(), password: _passwordInput.text.trim());
          if (_success) {
            navigate(context: context, page: await findStartScreen(), direction: 'right', fromDrawer: false);
          }
        } catch(e) {
          if (e.code == 'user-not-found') {
            showErrorDialog(
                context: context,
                headerText: 'Incorrect Email'.i18n,
                bodyText: 'No account exists under this email. If you wish to create an account using this email, please Register.'.i18n);
          } else if (e.code == 'wrong-password'){
            showErrorDialog(
                context: context,
                headerText: 'Incorrect Password'.i18n,
                bodyText: 'The password entered is not correct. If you have forgotten your password, you can start the password reset process.'.i18n);
          } else if (e.code == 'unknown') {
            if (! await checkNet()) {
              showErrorDialog(
                  context: context,
                  headerText: 'No Internet Connection'.i18n,
                  bodyText: 'Please check your internet connection and try again.'.i18n);
            } else {
              showErrorDialog(
                  context: context,
                  headerText: 'Sign In Failed'.i18n,
                  bodyText: 'An error has been encountered. Please try again.'.i18n);
                }
          } else {
            showErrorDialog(
                context: context,
                headerText: 'Sign In Failed'.i18n,
                bodyText: 'An error has been encountered. Please try again.'.i18n);
              }
            }
      } else {
        showErrorDialog(
            context: context,
            headerText: 'Invalid Password'.i18n,
            bodyText: 'The entered password is not valid.'.i18n);
      }
    } else {
      showErrorDialog(
          context: context,
          headerText: 'Invalid Email'.i18n,
          bodyText: 'The entered email address is not valid.'.i18n);
    }

    setState(() {
      _checking = false;
    });
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
          onTap: () {navigate(context: context, page: Register(), direction: 'right', fromDrawer: false);},
          child: Text("Register".i18n,
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
                color: primaryRed(),
                fontSize: displayWidth(context) * 0.032,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

}
