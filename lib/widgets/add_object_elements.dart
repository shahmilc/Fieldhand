import 'package:fieldhand/computation/general_functions.dart';
import 'package:fieldhand/widgets/flutter_rounded_date_picker-1.0.4-local/rounded_picker.dart';
import 'package:fieldhand/widgets/flutter_rounded_date_picker-1.0.4-local/src/material_rounded_date_picker_style.dart';
import 'file:///C:/Users/shahm/FlutterProjects/fieldhand/lib/widgets/selection_dialogs/options_dialog.dart';
import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/material.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:fieldhand/translations/options_dialog.i18n.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';

Widget addBody(
    {@required BuildContext context,
    @required String header,
    @required Widget child}) {
  return Center(
    child: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          iconTheme: IconThemeData(
            color: primaryRed(),
          ),
          backgroundColor: Colors.grey[50],
          expandedHeight: 150.0,
          flexibleSpace: Center(
              child: Container(
                  child: Text(
            header,
            style: GoogleFonts.notoSans(
                color: primaryRed(),
                fontSize: displayWidth(context) * 0.07,
                fontWeight: FontWeight.bold),
          ))),
        ),
        SliverToBoxAdapter(
          child: Container(
            width: displayWidth(context),
            color: Colors.transparent,
            child: Card(
              margin: EdgeInsets.all(0),
              color: primaryRed(),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(displayWidth(context) * 0.12),
                      topLeft: Radius.circular(displayWidth(context) * 0.12))),
              child: Wrap(
                children: <Widget>[
                  Center(child: child),
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}