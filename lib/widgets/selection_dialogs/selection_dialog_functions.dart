import 'package:fieldhand/computation/general_functions.dart';
import 'package:fieldhand/widgets/flutter_rounded_date_picker-1.0.4-local/rounded_picker.dart';
import 'package:fieldhand/widgets/flutter_rounded_date_picker-1.0.4-local/src/material_rounded_date_picker_style.dart';
import 'package:fieldhand/widgets/selection_dialogs/options_dialog.dart';
import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/material.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:fieldhand/translations/options_dialog.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';

// Button for options selection form
Widget optionsInputButton(
    {@required BuildContext context,
    @required String header,
    @required String hint,
    @required IconData icon,
    @required String objectTable,
    @required String objectColumn,
    @required ValueSetter fieldSetter,
    @required String fieldCurrent,
    @required List defaultValues,
    bool sortAlpha = false,
    @required Function handleReturn}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        header,
        style: GoogleFonts.notoSans(
            color: Colors.white,
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
            child: Container(
          child: FlatButton(
            padding:
                EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.004),
            child: Row(
              children: <Widget>[
                Icon(icon,
                    color: Colors.white, size: displayWidth(context) * 0.065),
                horizontalSpace(context, 0.03),
                fieldCurrent == null
                    ? Text(
                        hint,
                        style: GoogleFonts.notoSans(
                            color: Colors.white54,
                            fontSize: displayWidth(context) * 0.035),
                      )
                    : Text(
                        fieldCurrent,
                        style: GoogleFonts.notoSans(
                            color: Colors.white,
                            fontSize: displayWidth(context) * 0.04),
                      )
              ],
            ),
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => TypeOptionsDialog(
                        hideSearch: false,
                        searchStyle: GoogleFonts.notoSans(
                            color: Colors.white,
                            fontSize: displayWidth(context) * 0.04),
                        headerTitle: header,
                        searchDecoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          hintText: 'Search'.i18n,
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.notoSans(
                              color: Colors.white54,
                              fontSize: displayWidth(context) * 0.035),
                        ),
                        objectTable: objectTable,
                        objectColumns: objectColumn,
                        currentSelection: fieldCurrent,
                        sortAlpha: sortAlpha,
                        defaultOptions: defaultValues,
                      )).then((returnValue) => handleReturn(
                  fieldSetter: fieldSetter, returnValue: returnValue));
            },
          ),
        )),
      ),
    ],
  );
}

// Button for date picker
Widget dateInputButton(
    {@required BuildContext context,
    @required String header,
    @required String hint,
    @required IconData icon,
    @required ValueSetter fieldSetter,
    @required String fieldCurrent,
    @required Function handleReturn}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        header,
        style: GoogleFonts.notoSans(
            color: Colors.white,
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
            child: Container(
          child: FlatButton(
            padding:
                EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.004),
            child: Row(
              children: <Widget>[
                Icon(icon,
                    color: Colors.white, size: displayWidth(context) * 0.065),
                horizontalSpace(context, 0.03),
                fieldCurrent == null
                    ? Text(
                        hint,
                        style: GoogleFonts.notoSans(
                            color: Colors.white54,
                            fontSize: displayWidth(context) * 0.035),
                      )
                    : Text(
                        convertDate(fieldCurrent),
                        style: GoogleFonts.notoSans(
                            color: Colors.white,
                            fontSize: displayWidth(context) * 0.04),
                      )
              ],
            ),
            onPressed: () {
              showRoundedDatePicker(
                barrierDismissible:
                    true, // Flipped for some reason, true == false and false == true
                context: context,
                height: displayHeight(context) * 0.4,
                textPositiveButton: 'Select'.i18n,
                textNegativeButton: 'Cancel'.i18n,
                styleDatePicker: MaterialRoundedDatePickerStyle(
                    textStyleButtonNegative: GoogleFonts.notoSans(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: displayWidth(context) * 0.04),
                    textStyleButtonPositive: GoogleFonts.notoSans(
                        color: primaryRed(),
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.04)),
                locale: I18n.locale,
                fontFamily: GoogleFonts.notoSans().fontFamily,
                initialDate: (fieldCurrent != null)
                    ? DateTime.parse(fieldCurrent)
                    : DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 50),
                lastDate: DateTime.now(),
                borderRadius: displayWidth(context) * 0.07,
                description: 'Select Birth Date'.i18n,
                theme: ThemeData(
                    primarySwatch:
                        MaterialColor(0xFFFF6159, primaryRedColorMap)),
              ).then((date) => handleReturn(fieldSetter: fieldSetter, returnValue: date.toIso8601String())
              );
            },
          ),
        )),
      ),
    ],
  );
}
