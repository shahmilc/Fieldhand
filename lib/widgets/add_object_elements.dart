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

Widget textArea(
    {@required BuildContext context,
    @required String header,
    @required String hint,
    @required IconData icon,
    bool invert = false,
    TextEditingController editingController,
    Function onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        header,
        style: GoogleFonts.notoSans(
            color: invert ? Colors.white : primaryRed(),
            fontSize: displayWidth(context) * 0.03,
            fontWeight: FontWeight.bold),
      ),
      verticalSpace(context, 0.01),
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.002),
        width: displayWidth(context) * 0.75,
        decoration: roundedShadowDecoration(
            context: context, color: secondaryRed(), size: 0.015),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: editingController,
                keyboardType: TextInputType.multiline,
                onChanged: onChanged,
                minLines: 1,
                maxLines: 7,
                cursorColor: Colors.white,
                style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: displayWidth(context) * 0.04),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    icon,
                    color: Colors.white,
                    size: displayWidth(context) * 0.065,
                  ),
                  hintText: hint,
                  hintStyle: GoogleFonts.notoSans(
                      color: Colors.white54,
                      fontSize: displayWidth(context) * 0.035),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget selectionChips(
    {@required BuildContext context,
    @required String header,
    @required List options,
    @required int fieldCurrent,
    @required ValueSetter fieldSetter}) {
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
      verticalSpace(context, 0.005),
      Container(
        alignment: Alignment.centerLeft,
        height: displayHeight(context) * 0.067,
        width: displayWidth(context) * 0.75,
        padding: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.02),
        child: Center(
            child: Wrap(
          children: List<Widget>.generate(
            options.length,
            (int index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.01),
                child: ChoiceChip(
                    elevation: 3,
                    backgroundColor: Colors.white,
                    selectedColor: index == 0? Colors.green : index == 1? Colors.yellow : Colors.red,
                    label: SizedBox(
                        width: displayWidth(context) * 0.15,
                        child: Center(
                            child: Text(
                          options[index],
                          style: GoogleFonts.notoSans(
                              color: fieldCurrent == index
                                  ? Colors.white
                                  : index == 0
                                      ? Colors.green
                                      : index == 1 ? Colors.yellow : Colors.red,
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.bold),
                        ))),
                    selected: fieldCurrent == index,
                    onSelected: (bool selected) {
                      fieldSetter(selected? index : null);
                    }),
              );
            },
          ).toList(),
        )),
      ),
      verticalSpace(context, 0.01)
    ],
  );
}

checkBoxSelection({@required BuildContext context, @required String label, @required bool selection, @required Function(bool) onChanged}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Checkbox(value: selection,
        activeColor: Colors.white,
        checkColor: Color(0xFFFF6159),
        onChanged: onChanged),
      Text(
        label,
        style: GoogleFonts.notoSans(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: displayWidth(context) * 0.03,
        ),
      ),
    ],
  );
}
