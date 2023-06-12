import 'package:fieldhand/connectivity/auth_connection.dart';
import 'package:fieldhand/database/firebase_core.dart';
import 'package:fieldhand/start_up/farm/create_farm.dart';
import 'package:fieldhand/start_up/farm/farm_selection.dart';
import 'package:fieldhand/widgets/alert_dialogs.dart';
import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/central/dashboard.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/translations/login.i18n.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/start_up//country_code_picker-1.4.0-local/country_code_picker.dart';
import 'package:fieldhand/computation/navigation.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key key}) : super(key: key);

  final String routeName = 'CreateProfile';

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
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
                      borderRadius:
                          BorderRadius.circular(displayWidth(context) * 0.08),
                    ),
                    child: Wrap(
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: <Widget>[
                              verticalSpace(context, 0.015),
                              headerText(
                                  context: context,
                                  text: "Create Profile".i18n),
                              verticalSpace(context, 0.02),
                              Column(
                                children: <Widget>[
                                  imageThumbnail(
                                      context: context,
                                      size: 0.3,
                                      color: Color(0xFFFF998B)),
                                  verticalSpace(context, 0.01),
                                  Text(
                                    "Profile Image".i18n,
                                    style: GoogleFonts.notoSans(
                                        color: Color(0xFFFF6159),
                                        fontSize: displayWidth(context) * 0.03,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              verticalSpace(context, 0.03),
                              _nameInput(),
                              verticalSpace(context, 0.025)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(context, 0.02),
                generalBlueButton(
                    context: context,
                    text: "Create".i18n,
                    disabled: _checking,
                    loading: _checking,
                    function: () {_createProfile();}),
                verticalSpace(context, 0.02),
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  Widget _nameInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "First Name".i18n,
              style: GoogleFonts.notoSans(
                  color: Color(0xFFFF6159),
                  fontSize: displayWidth(context) * 0.03,
                  fontWeight: FontWeight.bold),
            ),
            verticalSpace(context, 0.01),
            Container(
              alignment: Alignment.centerLeft,
              height: displayHeight(context) * 0.067,
              width: displayWidth(context) * 0.35,
              decoration: roundedShadowDecoration(context: context, color: secondaryRed(), size: 0.015),
              child: TextField(
                controller: _firstName,
                cursorColor: Colors.white,
                style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: displayWidth(context) * 0.04),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.face,
                    color: Colors.white,
                    size: displayWidth(context) * 0.065,
                  ),
                  hintText: "First".i18n,
                  hintStyle: GoogleFonts.notoSans(
                      color: Colors.white54,
                      fontSize: displayWidth(context) * 0.035),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Last Name".i18n,
              style: GoogleFonts.notoSans(
                  color: Color(0xFFFF6159),
                  fontSize: displayWidth(context) * 0.03,
                  fontWeight: FontWeight.bold),
            ),
            verticalSpace(context, 0.01),
            Container(
              alignment: Alignment.centerLeft,
              height: displayHeight(context) * 0.067,
              width: displayWidth(context) * 0.35,
              decoration: roundedShadowDecoration(context: context, color: secondaryRed(), size: 0.015),
              child: TextField(
                controller: _lastName,
                cursorColor: Colors.white,
                style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: displayWidth(context) * 0.04),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: displayWidth(context) * 0.05),
                  hintText: "Last".i18n,
                  hintStyle: GoogleFonts.notoSans(
                      color: Colors.white54,
                      fontSize: displayWidth(context) * 0.035),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _createProfile() async {
    setState(() {
      _checking = true;
    });
    if (_firstName.text.trim().length > 0 && _lastName.text.trim().length > 0) {
      if (await FirebaseCore().addUser(firstName: _firstName.text.trim(), lastName: _lastName.text.trim())) {
        navigate(
            context: context,
            page: FarmSelection(),
            direction: 'right',
            fromDrawer: false);
      } else {
        showErrorDialog(
            context: context,
            headerText: 'Unable to create profile'.i18n,
            bodyText: 'Please try again.'.i18n);
      }
    } else {
      showErrorDialog(
          context: context,
          headerText: 'Enter valid name'.i18n,
          bodyText: 'Please enter a valid first and last name.'.i18n);
    }
    setState(() {
      _checking = false;
    });
  }
}
