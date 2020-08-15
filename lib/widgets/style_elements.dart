import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:google_fonts/google_fonts.dart';

Decoration roundedShadowDecoration({@required BuildContext context, @required Color color, @required double size}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(displayWidth(context) * size),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
}

InputDecoration miniSearchDecoration({@required BuildContext context, @required String text}) {
  return InputDecoration(
    prefixIcon: Icon(
      Icons.search,
      color: Colors.white,
    ),
    hintText: text,
    border: InputBorder.none,
    hintStyle: GoogleFonts.notoSans(
        color: Colors.white54,
        fontSize: displayWidth(context) * 0.035),
  );
}