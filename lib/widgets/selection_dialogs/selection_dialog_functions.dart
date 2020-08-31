import 'package:fieldhand/computation/general_functions.dart';
import 'package:fieldhand/widgets/flutter_rounded_date_picker-1.0.4-local/rounded_picker.dart';
import 'package:fieldhand/widgets/flutter_rounded_date_picker-1.0.4-local/src/material_rounded_date_picker_style.dart';
import 'package:fieldhand/widgets/selection_dialogs/image_selection_dialog.dart';
import 'package:fieldhand/widgets/selection_dialogs/link_selection_dialog.dart';
import 'package:fieldhand/widgets/selection_dialogs/option_selection_dialog.dart';
import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/material.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';

// Button for options selection form
Widget optionInputButton(
    {@required BuildContext context,
    @required String header,
    @required String hint,
    @required IconData icon,
    @required String objectTable,
    @required String objectColumn,
    @required ValueSetter fieldSetter,
    @required String fieldCurrent,
    @required List defaultValues,
      bool disabled = false,
      String disabledHint,
    bool sortAlpha = false}) {
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
      AnimatedOpacity(
        opacity: disabled? 0.5 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Container(
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
                          disabled? disabledHint : hint,
                          style: GoogleFonts.notoSans(
                              color: Colors.white54,
                              fontSize: displayWidth(context) * 0.035),
                        )
                      : Flexible(
                        child: Text(
                            fieldCurrent,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSans(
                                color: Colors.white,
                                fontSize: displayWidth(context) * 0.04),
                          ),
                      )
                ],
              ),
              onPressed: disabled? null : () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => OptionSelectionDialog(
                          hideSearch: false,
                          headerTitle: header,
                          searchDecoration: miniSearchDecoration(context: context, text: 'Search'.i18n),
                          objectTable: objectTable,
                          objectColumns: objectColumn,
                          currentSelection: fieldCurrent,
                          sortAlpha: sortAlpha,
                          defaultOptions: defaultValues,
                        )).then((returnValue) => returnValue != null? fieldSetter(returnValue) : null);
              },
            ),
          )),
        ),
      ),
    ],
  );
}

Widget linkInputButton(
    {@required BuildContext context,
      @required String header,
      @required String hint,
      @required IconData icon,
      @required String objectType,
      bool hideSearch = false,
      bool hideDropdown = false,
      bool multi = false,
      bool parentSelection = false,
      bool sireSelection = false,
      @required ValueSetter fieldSetter,
      @required String fieldCurrent,
      @required String currentId,
      bool disabled = false,
      String disabledHint = "",
      @required String origin,
      bool excludeOrigin = true}) {
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
      AnimatedOpacity(
        opacity: disabled? 0.5 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Container(
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
                      fieldCurrent == null || disabled
                          ? Text(
                        disabled? disabledHint : hint,
                        style: GoogleFonts.notoSans(
                            color: Colors.white54,
                            fontSize: displayWidth(context) * 0.035),
                      )
                          : currentId == null? Center(child: SizedBox(width: displayWidth(context) * 0.05, height: displayWidth(context) * 0.05,child: loadingIndicator(context: context, color: Colors.white))) :
                      Flexible(
                        child: Text(
                          currentId,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.notoSans(
                              color: Colors.white,
                              fontSize: displayWidth(context) * 0.04),
                        ),
                      )
                    ],
                  ),
                  onPressed: disabled? null : () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => LinkSelectionDialog(
                          hideSearch: hideSearch,
                          hideDropdown: hideDropdown,
                          multi: multi,
                          headerTitle: header,
                          searchDecoration: miniSearchDecoration(context: context, text: 'Search'.i18n),
                          objectType: objectType,
                          parentSelection: parentSelection,
                          sireSelection: sireSelection,
                          currentSelection: fieldCurrent,
                          origin: origin,
                          excludeOrigin: excludeOrigin
                        )).then((returnValue) => returnValue != null? fieldSetter(returnValue) : null);
                  },
                ),
              )),
        ),
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
      bool disabled = false,
      String disabledHint,
      bool future = false,
    bool bottomSpace = false,}) {
  DateTime now = DateTime.now();
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
      AnimatedOpacity(
        opacity: disabled? 0.5 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Container(
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
                          disabled? disabledHint : hint,
                          style: GoogleFonts.notoSans(
                              color: Colors.white54,
                              fontSize: displayWidth(context) * 0.035),
                        )
                      : Flexible(
                        child: Text(
                            convertDate(fieldCurrent),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSans(
                                color: Colors.white,
                                fontSize: displayWidth(context) * 0.04),
                          ),
                      )
                ],
              ),
              onPressed: disabled? null : () {
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
                      : now,
                  firstDate: future? now : DateTime(now.year - 50),
                  lastDate: future? DateTime(now.year + 50) : now,
                  borderRadius: displayWidth(context) * 0.07,
                  description: hint,
                  theme: ThemeData(
                      primarySwatch:
                          MaterialColor(0xFFFF6159, primaryRedColorMap)),
                ).then((date) => date != null? fieldSetter(date?.toIso8601String()) : null);
              },
            ),
          )),
        ),
      ),
      if (bottomSpace) verticalSpace(context, 0.03),
    ],
  );
}

Future<void> showImageSelectionDialog({
  @required BuildContext context,
  @required String header,
  @required String currentImage,
  @required List defaultImages,
  @required String objectSerial,
  @required ValueSetter fieldSetter}) async {
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => ImageSelectionDialog(
        headerTitle: header,
        imgList: defaultImages,
        currentImage: currentImage,
        objectSerial: objectSerial,
      )).then((selection) => selection != null? fieldSetter(selection) : null);
}
