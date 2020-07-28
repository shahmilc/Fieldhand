import 'package:fieldhand/central/livestock.dart';
import 'package:fieldhand/computation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:fieldhand/computation/transitions.dart';
import 'package:fieldhand/central/dashboard.dart';
import 'package:fieldhand/database/globals.dart' as globals;

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {

  @override
  void initState() {
    super.initState();
    globals.isDrawerOpen = true;
  }

  @override
  void dispose() {
    globals.isDrawerOpen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: displayHeight(context) * 0.93,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(displayWidth(context) * 0.05),
            bottomRight: Radius.circular(displayWidth(context) * 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(right: displayWidth(context) * 0.03),
        child: Drawer(
          elevation: 0,
          child: ListView(
            children: <Widget>[
              Container(
                color: Colors.grey[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: displayHeight(context) * 0.2,
                      width: displayWidth(context) * 0.7,
                      child: DrawerHeader(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              imageThumbnail(
                                  context: context,
                                  size: 0.25,
                                  color: primaryRed())
                            ],
                          )),
                    ),
                    Container(
                      width: displayWidth(context) * 0.70,
                      height: displayWidth(context) * 0.13,
                      child: RaisedButton(
                        elevation: 0,
                        color: primaryRed(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  displayWidth(context) * 0.05),
                              bottomRight: Radius.circular(
                                  displayWidth(context) * 0.05)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.dashboard, color: Colors.white),
                            Text(
                              "  Dashboard".i18n,
                              style: GoogleFonts.notoSans(
                                textStyle: TextStyle(color: Colors.white),
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          navigate(context: context, page: Dashboard(), direction: 'bottom', fromDrawer: true);
                        },
                      ),
                    ),
                    verticalSpace(context, 0.01),
                    Container(
                      width: displayWidth(context) * 0.70,
                      height: displayWidth(context) * 0.13,
                      child: RaisedButton(
                        elevation: 0,
                        color: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xFFFF998B)),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  displayWidth(context) * 0.05),
                              bottomRight: Radius.circular(
                                  displayWidth(context) * 0.05)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.child_friendly,
                              color: primaryRed(),
                            ),
                            Text(
                              "  Livestock".i18n,
                              style: GoogleFonts.notoSans(
                                textStyle: TextStyle(color: primaryRed()),
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          navigate(context: context, page: Livestock(), direction: 'bottom', fromDrawer: true);
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}