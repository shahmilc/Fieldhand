import 'package:fieldhand/branch/animal_entry.dart';
import 'package:fieldhand/computation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/translations/dashboard.i18n.dart';

class CentralSliverAppBar extends StatefulWidget {

  final String headerText;
  final Function(String) onSearch;

  CentralSliverAppBar({@required this.headerText, @required this.onSearch});

  @override
  _CentralSliverAppBarState createState() => _CentralSliverAppBarState();
}

class _CentralSliverAppBarState extends State<CentralSliverAppBar> {

  final FocusNode _focusNode = FocusNode();

  bool _activeSearchBar = false;

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: Builder(
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
              size: displayWidth(context) * 0.07,
            )),
      ),
      floating: true,
      expandedHeight: displayHeight(context) * 0.3,
      actions: <Widget>[
        IconButton(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
          },
          icon: Icon(
            Icons.sync,
            color: Colors.white,
            size: displayWidth(context) * 0.07,
          ))],
      // Display a placeholder widget to visualize the shrinking size.
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.zero,
              height: displayHeight(context) * 0.25,
              width: displayWidth(context),
              decoration: BoxDecoration(
                color: primaryRed(),
                borderRadius: BorderRadius.only(
                    bottomLeft:
                    Radius.circular(displayWidth(context) * 0.15),
                    bottomRight:
                    Radius.circular(displayWidth(context) * 0.15)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: displayHeight(context) * 0.1,
                    left: displayWidth(context) * 0.13),
                child: Container(
                    child: Text(
                      widget.headerText,
                      style: GoogleFonts.notoSans(
                          textStyle: TextStyle(color: Colors.white),
                          fontSize: displayWidth(context) * 0.08,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: displayHeight(context) * 0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _sideButton(text: 'Add'.i18n, icon: Icons.add, function: () {navigate(context: context, page: AnimalEntry(edit: false), direction: 'right', fromDrawer: false);}),
                  horizontalSpace(context, 0.02),
                  _searchField(),
                  horizontalSpace(context, 0.02),
                  _sideButton(text: 'Sort'.i18n, icon: Icons.sort, function: () {})
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _searchField() {
    return Padding(
      padding: EdgeInsets.only(
          top: displayHeight(context) * 0.02),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: displayWidth(context) * (_activeSearchBar? 0.65 : 0.33),
        height: displayHeight(context) * 0.055,
        child: RaisedButton(
          elevation: 8,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                displayWidth(context) * 0.05),
          ),
          child: Row(
            mainAxisAlignment: _activeSearchBar? MainAxisAlignment.start : MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    onTap: () {setState(() {
                      _activeSearchBar = true;
                    });},
                    onEditingComplete: () {setState(() {
                      _focusNode.unfocus();
                      _activeSearchBar = false;
                    });},
                    onChanged: widget.onSearch,
                    cursorColor: primaryRed(),
                    style: GoogleFonts.notoSans(color: Colors.black54, fontSize: displayWidth(context) * 0.035),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        size: displayWidth(context) * 0.06,
                        color: secondaryRed(),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Search'.i18n,
                      hintStyle: GoogleFonts.notoSans(
                          color: secondaryRed(),
                          textStyle:
                          TextStyle(color: Colors.white),
                          fontSize:
                          displayWidth(context) * 0.035,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          ),
          onPressed: () {},
        ),
      ),
    );
  }

  _sideButton({@required String text, @required IconData icon, Function function}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      width: displayWidth(context) * (_activeSearchBar? 0.13 : 0.25),
      height: displayHeight(context) * 0.055,
      child: RaisedButton(
        elevation: 8,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              displayWidth(context) * 0.05),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: displayWidth(context) * 0.05,
              color: secondaryRed(),
            ),
            Expanded(
              child: AnimatedOpacity(
                opacity: _activeSearchBar? 0 : 1.0,
                duration: Duration(milliseconds: 150),
                child: Text(
                  '  $text',
                  style: GoogleFonts.notoSans(
                      color: secondaryRed(),
                      textStyle:
                      TextStyle(color: Colors.white),
                      fontSize: displayWidth(context) * 0.035,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        onPressed: function,
      ),
    );
  }

}