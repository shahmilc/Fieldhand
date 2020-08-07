import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/material.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:google_fonts/google_fonts.dart';

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

Widget textArea({
  @required BuildContext context,
  @required String header,
  @required String hint,
  @required IconData icon,
  bool invert = false,
  Function onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        header,
        style: GoogleFonts.notoSans(
            color: invert? Colors.white : primaryRed(),
            fontSize: displayWidth(context) * 0.03,
            fontWeight: FontWeight.bold),
      ),
      verticalSpace(context, 0.01),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.002),
        width: displayWidth(context) * 0.75,
        decoration: roundedShadowDecoration(context: context, color: secondaryRed(), size: 0.015),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TextField(
                keyboardType: TextInputType.multiline,
                onChanged: onChanged,
                minLines: 1,
                maxLines: 7,
                cursorColor: Colors.white,
                style: GoogleFonts.notoSans(
                    color: Colors.white, fontSize: displayWidth(context) * 0.04),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    icon,
                    color: Colors.white,
                    size: displayWidth(context) * 0.065,
                  ),
                  hintText: hint,
                  hintStyle: GoogleFonts.notoSans(
                      color: Colors.white54, fontSize: displayWidth(context) * 0.035),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}