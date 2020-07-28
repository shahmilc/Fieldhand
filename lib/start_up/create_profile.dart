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
                              cardHeader(
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
                              nameInput(),
                              verticalSpace(context, 0.03),
                              countrySelection(),
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
                    function: () {
                      navigate(
                          context: context,
                          page: Dashboard(),
                          direction: 'right',
                          fromDrawer: false);
                    }),
                verticalSpace(context, 0.02),
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget nameInput() {
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

  Widget countrySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Country".i18n,
          style: GoogleFonts.notoSans(
              color: primaryRed(),
              fontSize: displayWidth(context) * 0.03,
              fontWeight: FontWeight.bold),
        ),
        verticalSpace(context, 0.01),
        Container(
          alignment: Alignment.centerLeft,
          height: displayHeight(context) * 0.067,
          width: displayWidth(context) * 0.75,
          decoration: roundedShadowDecoration(
              context: context, color: secondaryRed(), size: 0.015),
          padding: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.02),
          child: Center(
            child: CountryCodePicker(
              textStyle: GoogleFonts.notoSans(
                  color: Colors.white, fontSize: displayWidth(context) * 0.04),
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: 'US',
              dialogTextStyle: GoogleFonts.notoSans(
                  color: Colors.black54, fontSize: displayWidth(context) * 0.04),
              favorite: ['US', 'CA', 'AU', 'GB', 'FR', 'DE', 'RU'],
              // optional. Shows only country name and flag
              showCountryOnly: true,
              showDropIcon: true,
              searchStyle: GoogleFonts.notoSans(
                  color: Colors.white, fontSize: displayWidth(context) * 0.04),
              searchDecoration: InputDecoration(
                hintText: 'Search'.i18n,
                border: InputBorder.none,
                hintStyle: GoogleFonts.notoSans(
                    color: Colors.white54,
                    fontSize: displayWidth(context) * 0.035),
              ),
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: true,
              // optional. aligns the flag and the Text left
              alignLeft: true,
            ),
          ),
        ),
      ],
    );
  }
}
