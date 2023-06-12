import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/widgets/drawer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/translations/dashboard.i18n.dart';
import 'package:fieldhand/computation/transitions.dart';
import 'package:fieldhand/database/globals.dart' as globals;

class Dashboard extends StatefulWidget {
  Dashboard({Key key, @required this.farmId}) : super(key: key);

  final String routeName = 'Dashboard';
  final String farmId;

  @override
  _DashboardState createState() => _DashboardState(farmId);
}

class _DashboardState extends State<Dashboard> {

  _DashboardState(this.farmId);
  final String farmId;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPress(context: context),
      child: Scaffold(
          drawer: SideDrawer(farmId: farmId),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                leading: Builder(
                  builder: (context) => Padding(
                    padding:
                    EdgeInsets.only(bottom: displayHeight(context) * 0.015),
                    child: IconButton(
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
                ),
                floating: true,
                expandedHeight: displayHeight(context) * 0.3,
                // Display a placeholder widget to visualize the shrinking size.
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(0),
                        height: displayHeight(context) * 0.25,
                        width: displayWidth(context),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF6159),
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
                                "Livestock".i18n,
                                style: GoogleFonts.notoSans(
                                    textStyle: TextStyle(color: Colors.white),
                                    fontSize: displayWidth(context) * 0.08,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.only(top: displayHeight(context) * 0.2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: displayWidth(context) * 0.21,
                              height: displayHeight(context) * 0.055,
                              child: RaisedButton(
                                elevation: 6,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      displayWidth(context) * 0.05),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      size: displayWidth(context) * 0.04,
                                      color: Color(0xFFFF998B),
                                    ),
                                    Text(
                                      "Add".i18n,
                                      style: GoogleFonts.notoSans(
                                          color: Color(0xFFFF998B),
                                          textStyle:
                                          TextStyle(color: Colors.white),
                                          fontSize: displayWidth(context) * 0.035,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                            horizontalSpace(context, 0.02),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: displayHeight(context) * 0.02),
                              child: Container(
                                width: displayWidth(context) * 0.3,
                                height: displayHeight(context) * 0.055,
                                child: RaisedButton(
                                  elevation: 6,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        displayWidth(context) * 0.05),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Icon(
                                        Icons.search,
                                        size: displayWidth(context) * 0.05,
                                        color: Color(0xFFFF998B),
                                      ),
                                      Text(
                                        "Search".i18n,
                                        style: GoogleFonts.notoSans(
                                            color: Color(0xFFFF998B),
                                            textStyle:
                                            TextStyle(color: Colors.white),
                                            fontSize:
                                            displayWidth(context) * 0.035,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            horizontalSpace(context, 0.02),
                            Container(
                              width: displayWidth(context) * 0.21,
                              height: displayHeight(context) * 0.055,
                              child: RaisedButton(
                                elevation: 6,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      displayWidth(context) * 0.05),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      Icons.sort,
                                      size: displayWidth(context) * 0.04,
                                      color: Color(0xFFFF998B),
                                    ),
                                    Text(
                                      "Sort".i18n,
                                      style: GoogleFonts.notoSans(
                                          color: Color(0xFFFF998B),
                                          textStyle:
                                          TextStyle(color: Colors.white),
                                          fontSize: displayWidth(context) * 0.035,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => ListTile(title: Text('Item #$index')),
                  // Builds 1000 ListTiles
                  childCount: 30,
                ),
              )
            ],
          )),
    );
  }
}
