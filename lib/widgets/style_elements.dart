import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fieldhand/screen_sizing.dart';

roundedShadowDecoration({@required BuildContext context, @required Color color, @required double   size}) {
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