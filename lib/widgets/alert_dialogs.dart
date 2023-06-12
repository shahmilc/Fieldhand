import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/default.i18n.dart';

void showErrorDialog({@required BuildContext context, @required String headerText, @required String bodyText}) {
  // flutter defined function
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(displayWidth(context) * 0.07))),
              title: Container(
              child: Text(
                headerText,
                style: GoogleFonts.notoSans(
                    textStyle: TextStyle(color: primaryRed()),
                    fontSize: displayWidth(context) * 0.055,
                    fontWeight: FontWeight.w400),
              )),
              children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: displayWidth(context) * 0.05,
                        vertical: displayHeight(context) * 0.02),
                    child: Wrap(
                      runSpacing: displayHeight(context) * 0.03,
                      children: <Widget>[
                        Text(
                            bodyText,
                            style: GoogleFonts.notoSans(
                                fontSize: displayWidth(context) * 0.035,
                                fontWeight: FontWeight.w200,
                                letterSpacing: displayWidth(context) * 0.005,
                                color: Colors.black45)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          "Close",
                            style: GoogleFonts.notoSans(
                                fontSize: displayWidth(context) * 0.035,
                                fontWeight: FontWeight.w200,
                                letterSpacing: displayWidth(context) * 0.005,
                                color: Colors.grey)
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
            );
      });
}