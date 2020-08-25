import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget mainList({@required ScrollController controller, @required Widget item({@required int index}), @required int itemCount}) {
  return Scrollbar(
    child: Container(
      child: ListView.builder(
        controller: controller,
        itemBuilder: (BuildContext context, int index) {
          return item(index: index);
        },
        itemCount: itemCount,
      ),
    ),
  );
}

Widget buttonRow({@required BuildContext context, @required String selection, @required bool disabled}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      MaterialButton(
        child: Text(
          "Cancel",
          style: GoogleFonts.notoSans(
              color: Colors.grey,
              //fontWeight: FontWeight.bold,
              fontSize: displayWidth(context) * 0.04),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      Opacity(
        opacity: disabled? 0.4 : 1.0,
        child: MaterialButton(
          child: Text(
            "Select",
            style: GoogleFonts.notoSans(
                color: primaryRed(),
                fontWeight: FontWeight.bold,
                fontSize: displayWidth(context) * 0.04),
          ),
          onPressed: disabled ? null : () {
            Navigator.pop(context, selection);
          },
        ),
      ),
    ],
  );
}

Widget scrollIndicator({@required BuildContext context, @required bool scrollLeft}) {
  return Container(
      padding: EdgeInsets.only(top: displayHeight(context) * 0.01),
      height: displayHeight(context) * 0.02,
      child: AnimatedOpacity(
        opacity: scrollLeft ? 1.0 : 0.0,
        duration: Duration(milliseconds: 250),
        child: Icon(
          Icons.keyboard_arrow_down,
          color: primaryRed(),
        ),
      ));
}

Widget searchBar({@required BuildContext context, @required Function(String) filterFunction, @required InputDecoration searchDecoration}) {
  return Container(
    alignment: Alignment.centerLeft,
    height: displayHeight(context) * 0.067,
    width: displayWidth(context) * 0.75,
    decoration: roundedShadowDecoration(
        context: context, color: secondaryRed(), size: 0.015),
    child: TextField(
      onChanged: (value) => filterFunction(value),
      cursorColor: Colors.white,
      style: GoogleFonts.notoSans(
          color: Colors.white,
          fontSize: displayWidth(context) * 0.04),
      decoration: searchDecoration,
    ),
  );
}

Widget noResults({@required BuildContext context, @required bool opaque}) {
  return Opacity(
    opacity: opaque? 1.0 : 0.0,
    child: Center(child: Text("No Results", style: GoogleFonts.notoSans(
      color: Colors.black38,
      fontSize: displayWidth(context) * 0.04,
    ),)),
  );
}