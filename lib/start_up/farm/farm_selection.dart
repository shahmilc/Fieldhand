import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/start_up/farm/create_farm.dart';
import 'package:fieldhand/widgets/drawer.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i18n_extension/default.i18n.dart';

class FarmSelection extends StatefulWidget {
  FarmSelection({Key key}) : super(key: key);

  final String routeName = 'FarmSelection';

  @override
  _FarmSelectionState createState() => _FarmSelectionState();
}

class _FarmSelectionState extends State<FarmSelection> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => onBackPress(context: context),
        child: Scaffold(
          backgroundColor: primaryRed(),
          body: Center(
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  verticalSpace(context, 0.02),
                  headerText(context: context, inverted: true, text: "You're not part of a Farm!".i18n),
                  verticalSpace(context, 0.1),
                  headerText(context: context, inverted: true, text: "Create or Join a Farm".i18n),
                  verticalSpace(context, 0.1),
                  generalBlueButton(context: context, text: "Create".i18n, disabled: false, function: () {navigate(context: context, page: CreateFarm(), direction: 'right', fromDrawer: false);}),
                  verticalSpace(context, 0.12),
                  generalBlueButton(context: context, text: "Join".i18n, disabled: true, function: () {}),

                ],
              ),
            ),
          ),
        ));
  }
}