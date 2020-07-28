import 'dart:io';
import 'package:fieldhand/widgets/custom_icons_icons.dart';
import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:google_fonts/google_fonts.dart';

Widget generalBlueButton({@required BuildContext context, @required String text, void Function() function}) {
  return Container(
    width: displayWidth(context) * 0.75,
    height: displayHeight(context) * 0.07,
    child: RaisedButton(
      elevation: 5,
      color: Color(0xFF5CBDEA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.015),
      ),
      child: Text(
        text,
        style: GoogleFonts.notoSans(
            textStyle: TextStyle(color: Colors.white),
            fontSize: displayWidth(context) * 0.05,
            fontWeight: FontWeight.w800,
            letterSpacing: displayWidth(context) * 0.005),
      ),
      onPressed: function,
    ),
  );
}

Widget imageThumbnail({@required BuildContext context, String imagePath = 'assets/img/objectImages/default.png', @required double size, @required Color color}) {
  return Container(
    width: displayWidth(context) * size,
    height: displayWidth(context) * size,
    decoration: roundedShadowDecoration(context: context, color: color, size: size * 0.2),
    alignment: Alignment.center,
    child: Container(
      width: displayWidth(context) * (size * 0.93),
      height: displayWidth(context) * (size * 0.93),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(displayWidth(context) * size * 0.2),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            getImageFile(item: imagePath),
            SizedBox(
              height: displayWidth(context) * size * 0.25,
              width: displayWidth(context) * size,
              child: Container(
                color: primaryRed().withOpacity(0.85),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(CustomIcons.images, color: Colors.white.withOpacity(0.9),),
                    horizontalSpace(context, 0.03),
                    Text("Edit", style: GoogleFonts.notoSans(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: displayWidth(context) * 0.04),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

getImageFile({@required String item}) {
  if (item.split('/')[0] == 'assets') {
    return Image.asset(
      item,
    );
  } else {
    return Image.file(
      File(item),
    );
  }
}

Widget topBar({@required BuildContext context}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(displayHeight(context) * 0.03),
    child: AppBar(
      backgroundColor: Color(0xFFFF6159),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Builder(
            builder: (context) => IconButton(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    ),
  );
}

Widget inputForm({@required BuildContext context, @required String header, @required String hint, bool obscure, @required IconData icon, bool invert, Function onChanged}) {
  if (invert == null) invert = false;
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
        height: displayHeight(context) * 0.067,
        width: displayWidth(context) * 0.75,
        decoration: roundedShadowDecoration(context: context, color: secondaryRed(), size: 0.015),
        child: TextField(
          onChanged: onChanged,
          obscureText: obscure != null ? obscure : false,
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
  );
}

Widget cardHeader({@required BuildContext context, @required String text}) {
  return Container(
      child: Text(
    text,
    style: GoogleFonts.notoSans(
        textStyle: TextStyle(color: Color(0xFFFF6159)),
        fontSize: displayWidth(context) * 0.06,
        fontWeight: FontWeight.w800),
  ));
}

Widget socialRow({@required BuildContext context, @required Function function}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      RawMaterialButton(
        onPressed: function,
        elevation: 6.0,
        fillColor: Colors.white,
        child: Image.asset(
          "assets/img/signin/facebookf.png",
          height: displayHeight(context) * 0.045,
        ),
        padding: EdgeInsets.all(displayWidth(context) * 0.04),
        shape: CircleBorder(),
      ),
      horizontalSpace(context, 0.1),
      RawMaterialButton(
        onPressed: () {},
        elevation: 6.0,
        fillColor: Colors.white,
        child: Image.asset(
          "assets/img/signin/googleg.png",
          height: displayHeight(context) * 0.045,
        ),
        padding: EdgeInsets.all(displayWidth(context) * 0.04),
        shape: CircleBorder(),
      )
    ],
  );
}

Widget contactUsRow({@required BuildContext context, @required String text1, @required String text2, Function function}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(text1,
          style: GoogleFonts.notoSans(
              fontSize: displayWidth(context) * 0.03,
              fontWeight: FontWeight.w200,
              letterSpacing: displayWidth(context) * 0.005,
              color: Colors.white)),
      GestureDetector(
        onTap: function,
        child: Text(text2,
            style: GoogleFonts.notoSans(
                fontSize: displayWidth(context) * 0.033,
                fontWeight: FontWeight.w800,
                letterSpacing: displayWidth(context) * 0.005,
                color: Colors.white)),
      ),
    ],
  );
}

loadingIndicator({@required BuildContext context}) {
  return Center(
    child: SizedBox(
      height: displayWidth(context) * 0.12,
      width: displayWidth(context) * 0.12,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primaryRed()),
        strokeWidth: 1,
      ),
    ),
  );
}

Color primaryRed() {
  return Color(0xFFFF6159);
}

Color secondaryRed() {
  return Color(0xFFFF998B);
}

Color primaryFaded() {
  return Color(0xFFBF9F9F);
}

Map<int, Color> primaryRedColorMap = {
  50: Color.fromRGBO(255, 97, 89, .1),
  100: Color.fromRGBO(255, 97, 89, .2),
  200: Color.fromRGBO(255, 97, 89, .3),
  300: Color.fromRGBO(255, 97, 89, .4),
  400: Color.fromRGBO(255, 97, 89, .5),
  500: Color.fromRGBO(255, 97, 89, .6),
  600: Color.fromRGBO(255, 97, 89, .7),
  700: Color.fromRGBO(255, 97, 89, .8),
  800: Color.fromRGBO(255, 97, 89, .9),
  900: Color.fromRGBO(255, 97, 89, 1),
};