import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/computation/screen_router.dart';
import 'package:fieldhand/start_up/create_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/translations/login.i18n.dart';
import 'package:fieldhand/connectivity/auth_connection.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/alert_dialogs.dart';
import 'package:fieldhand/computation/general_functions.dart';


class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  final String routeName = 'Register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController _emailInput = TextEditingController();
  TextEditingController _passwordInput = TextEditingController();
  TextEditingController _passwordConfirmInput = TextEditingController();

  bool _privacyPolicyAgree = false;
  bool _checking = false;

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
                              headerText(context: context, text: "Register".i18n),
                              verticalSpace(context, 0.015),
                              inputForm(context: context, header: "Email".i18n, hint: "Enter your email".i18n, icon: Icons.email, editingController: _emailInput),
                              verticalSpace(context, 0.025),
                              inputForm(context: context, header: "Password".i18n, hint: "Enter a password".i18n, obscure: true, icon: Icons.vpn_key, editingController: _passwordInput),
                              verticalSpace(context, 0.025),
                              inputForm(context: context, header: "Confirm Password".i18n, hint: "Reenter password".i18n, obscure: true, icon: Icons.vpn_key, editingController: _passwordConfirmInput),
                              verticalSpace(context, 0.025),
                              privacyPolicyRow(),
                              verticalSpace(context, 0.025),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(context, 0.02),
                generalBlueButton(context: context, text: "Register".i18n, disabled: _checking, loading: _checking, function: () {registrationCheck();}),
                verticalSpace(context, 0.1),
                contactUsRow(context: context, text1: "Having problems? ".i18n, text2: "Contact Us".i18n, function: () {})
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
    _passwordConfirmInput.dispose();
    super.dispose();
  }

  registrationCheck() async {
    setState(() {
      _checking = true;
    });
    if (RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(_emailInput.text.trim())) {
      if (RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$").hasMatch(_passwordInput.text.trim())) {
        if (_passwordInput.text.trim() == _passwordConfirmInput.text.trim()) {
          if (_privacyPolicyAgree) {
            try {
              bool _success = await FirebaseAuthorization().register(email: _emailInput.text.trim(), password: _passwordInput.text.trim());
              if (_success) {
                navigate(context: context, page: await findStartScreen(), direction: 'right', fromDrawer: false);
              }
            } catch(e) {
              if (e.code == 'email-already-in-use') {
                showErrorDialog(
                    context: context,
                    headerText: 'Account already exists'.i18n,
                    bodyText: 'An account already exists for this email. Please go back and Sign In.'.i18n);
              } else if (e.code == 'unknown') {
                if (! await checkNet()) {
                  showErrorDialog(
                      context: context,
                      headerText: 'No Internet Connection'.i18n,
                      bodyText: 'Please check your internet connection and try again.'.i18n);
                } else {
                  showErrorDialog(
                      context: context,
                      headerText: 'Registration Failed'.i18n,
                      bodyText: 'An error has been encountered. Please try again.'.i18n);
                }
              } else {
                showErrorDialog(
                    context: context,
                    headerText: 'Registration Failed'.i18n,
                    bodyText: 'An error has been encountered. Please try again.'.i18n);
              }
            }
          } else {
            showErrorDialog(
                context: context,
                headerText: 'Accept Privacy Policy'.i18n,
                bodyText: 'To register, you must accept the Fieldhand Privacy Policy. Please check the box to accept the policy.'.i18n);
          }
        } else {
          showErrorDialog(
              context: context,
              headerText: 'Passwords Must Match'.i18n,
              bodyText: 'Both password fields must match. Please enter the same password for both fields.'.i18n);
        }
      } else {
        showErrorDialog(
            context: context,
            headerText: 'Invalid Password'.i18n,
            bodyText: 'Your password must be at least 6 characters long, and contain at least 1 letter and 1 number.'.i18n);
      }
    } else {
      showErrorDialog(
          context: context,
          headerText: 'Invalid Email'.i18n,
          bodyText: '${_emailInput.text} is not a valid email address. Please enter your real email address.'.i18n);
    }
    setState(() {
      _checking = false;
    });
  }

  Widget privacyPolicyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(value: _privacyPolicyAgree,
        activeColor: Color(0xFFFF6159),
        checkColor: Colors.white,
        onChanged: (bool newValue) {setState(() {
          _privacyPolicyAgree = newValue;
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
