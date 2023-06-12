import 'dart:io';
import 'package:fieldhand/widgets/custom_icons_icons.dart';
import 'package:fieldhand/widgets/selection_dialogs/selection_dialog_functions.dart';
import 'package:fieldhand/widgets/style_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/default.i18n.dart';

Widget generalBlueButton({@required BuildContext context, @required String text, void Function() function, bool disabled = false, bool loading = false}) {
  return Opacity(
    opacity: disabled? 0.5 : 1.0,
    child: Container(
      width: displayWidth(context) * 0.75,
      height: displayHeight(context) * 0.07,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF5CBDEA)),
          elevation: MaterialStateProperty.all<double>(5.0),
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.015)))
        ),
        child: loading?
          loadingIndicator(context: context, color: Colors.white, sizeFactor: 0.8) :
          Text(
          text,
          style: GoogleFonts.notoSans(
              textStyle: TextStyle(color: Colors.white),
              fontSize: displayWidth(context) * 0.05,
              fontWeight: FontWeight.w800,
              letterSpacing: displayWidth(context) * 0.005),
        ),
        onPressed: disabled? null : function,
      ),
    ),
  );
}

Widget imageThumbnail(
    {@required BuildContext context,
      String imagePath = 'assets/img/objectImages/default.png',
      @required double size,
      @required Color color,
      bool editable = false,
      String editHeader,
      List defaultImages,
      ValueSetter fieldSetter,
      String objectSerial,
      bool readBytes = false}) {
  if (editHeader == null) editHeader = "Image".i18n;
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
            getImageFile(item: imagePath, readBytes: readBytes),
            if (editable) SizedBox(
              height: displayWidth(context) * size * 0.25,
              width: displayWidth(context) * size,
              child: InkWell(
                onTap: () => showImageSelectionDialog(context: context, header: editHeader, currentImage: imagePath, defaultImages: defaultImages, fieldSetter: fieldSetter, objectSerial: objectSerial),
                child: Container(
                  color: primaryRed().withOpacity(0.85),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(CustomIcons.images, color: Colors.white.withOpacity(0.9),),
                      horizontalSpace(context, 0.03),
                      Text("Edit".i18n, style: GoogleFonts.notoSans(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: displayWidth(context) * 0.04),)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

getImageFile({@required String item, @required bool readBytes}) {
  if (item.split('/')[0] == 'assets') {
    return Image.asset(item);
  } else if (readBytes) {
    return Image.memory(File(item).readAsBytesSync());
  } else {
    return Image.file(File(item));
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

Widget inputForm({@required BuildContext context, @required String header, @required String hint, bool obscure = false, @required IconData icon, bool invert = false, Function onChanged, int maxLength = 30, TextEditingController editingController, Iterable<String> autoFillHints}) {
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
          autofillHints: autoFillHints,
          controller: editingController,
          onChanged: onChanged,
          obscureText: obscure,
          cursorColor: Colors.white,
          style: GoogleFonts.notoSans(color: Colors.white, fontSize: displayWidth(context) * 0.04),
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength),
          ],
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

Widget textDivider({@required BuildContext context, @required String text, @required Color color, double scaleFactor = 1.0, bool enabled = true, bool padding = false}) {
  return enabled? Padding(
    padding: EdgeInsets.symmetric(vertical: padding? displayHeight(context) * 0.03 : 0),
    child: Row(
      children: <Widget>[
        Expanded(
            child: Divider(
              indent: displayWidth(context) * 0.25 / scaleFactor,
              endIndent: displayWidth(context) * 0.04 / scaleFactor,
              color: color,
            )),
        Text(text,
            style: GoogleFonts.notoSans(
                fontSize: displayWidth(context) * 0.025 * scaleFactor,
                fontWeight: FontWeight.w200,
                letterSpacing: displayWidth(context) * 0.005 * scaleFactor,
                color: color)),
        Expanded(
            child: Divider(
              indent: displayWidth(context) * 0.04 / scaleFactor,
              endIndent: displayWidth(context) * 0.25 / scaleFactor,
              color: color,
            )),
      ],
    ),
  ) : Container();
}

Widget headerText({@required BuildContext context, @required String text, inverted: false, size: 0.06}) {
  return Container(
      child: Text(
    text,
    style: GoogleFonts.notoSans(
        textStyle: TextStyle(color: inverted? Colors.white : primaryRed()),
        fontSize: displayWidth(context) * size,
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

loadingIndicator({@required BuildContext context, Color color, double sizeFactor = 1.0, bool showLogo = false}) {
  return Stack(
    children: [
      Center(
        child: SizedBox(
          height: displayWidth(context) * 0.12 * sizeFactor,
          width: displayWidth(context) * 0.12 * sizeFactor,
          child: CircularProgressIndicator(
            valueColor: color != null? AlwaysStoppedAnimation<Color>(color) : AlwaysStoppedAnimation<Color>(primaryRed()),
            strokeWidth: 1,
          ),
        ),
      ),
      Opacity(
        opacity: showLogo? 1 : 0,
        child: Center(
          child: SizedBox(
            height: displayWidth(context) * 0.065 * sizeFactor,
            width: displayWidth(context) * 0.065 * sizeFactor,
            child: Image.asset('assets/img/icon/letter.png')),
        )
        ),
    ],
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