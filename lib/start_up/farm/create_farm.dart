import 'package:fieldhand/central/dashboard.dart';
import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/connectivity/auth_connection.dart';
import 'package:fieldhand/database/firebase_core.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/start_up/country_code_picker-1.4.0-local/country_code_picker.dart';
import 'package:fieldhand/widgets/alert_dialogs.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/default.i18n.dart';

class CreateFarm extends StatefulWidget {
  CreateFarm({Key key}) : super(key: key);

  final String routeName = 'CreateFarm';

  @override
  _CreateFarmState createState() => _CreateFarmState();
}

class _CreateFarmState extends State<CreateFarm> {

  TextEditingController _farmName = TextEditingController();

  bool _checking = false;
  String _countrySelection = "United States";

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
                              headerText(
                                  context: context, text: "Create Farm".i18n),
                              verticalSpace(context, 0.015),
                              inputForm(context: context,
                                  header: "Farm Name".i18n,
                                  hint: "Name your farm".i18n,
                                  icon: Icons.house_siding_rounded,
                                  editingController: _farmName),
                              verticalSpace(context, 0.025),
                              countrySelection(),
                              verticalSpace(context, 0.025),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(context, 0.02),
                generalBlueButton(context: context,
                    text: "Create".i18n,
                    disabled: _checking,
                    loading: _checking,
                    function: () {_createFarm();}),
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
    _farmName.dispose();
    super.dispose();
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
              onChanged: (selection) => _countrySelection = selection.name,
            ),
          ),
        ),
      ],
    );
  }

  _createFarm() async {
    setState(() {
      _checking = true;
    });
    if (_farmName.text.trim().length > 1) {
      if (await FirebaseCore().createFarm(farmName: _farmName.text.trim(), country: _countrySelection)) {
        navigate(
            context: context,
            page: Dashboard(farmId: (await FirebaseCore().retrieveFarms()).first),
            direction: 'right',
            fromDrawer: false);
      } else {
        showErrorDialog(
            context: context,
            headerText: 'Unable to create farm'.i18n,
            bodyText: 'Please try again.'.i18n);
      }
    } else {
      showErrorDialog(
          context: context,
          headerText: 'Enter valid name'.i18n,
          bodyText: 'Please enter a farm name.'.i18n);
    }
    setState(() {
      _checking = false;
    });
  }

}