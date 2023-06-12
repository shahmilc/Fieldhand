import 'package:fieldhand/central/livestock.dart';
import 'package:fieldhand/computation/navigation.dart';
import 'package:fieldhand/connectivity/auth_connection.dart';
import 'package:fieldhand/database/firebase_core.dart';
import 'package:fieldhand/start_up/login.dart';
import 'package:fieldhand/widgets/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:fieldhand/central/dashboard.dart';
import 'package:fieldhand/database/globals.dart' as globals;

class SideDrawer extends StatefulWidget {
  SideDrawer({@required this.farmId});
  final String farmId;
  @override
  _SideDrawerState createState() => _SideDrawerState(farmId);
}

class _SideDrawerState extends State<SideDrawer> {

  _SideDrawerState(this.farmId);
  final String farmId;
  String _currentRoute = globals.routeStack.last;

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
                    _drawerHeader(),
                    _selectionTile(text: 'Dashboard'.i18n, icon: Icons.view_list, iconSize: 0.09, page: Dashboard(farmId: farmId,)),
                    verticalSpace(context, 0.011),
                   _selectionTile(text: 'Livestock'.i18n, icon: CustomIcons.horse, iconSize: 0.07, page: Livestock(farmId: farmId)),
                    verticalSpace(context, 0.011),
                    _selectionTile(text: 'Machinery'.i18n, icon: CustomIcons.tractor, iconSize: 0.065, page: Livestock(farmId: farmId)),
                    verticalSpace(context, 0.011),
                    _selectionTile(text: 'Fields'.i18n, icon: CustomIcons.crop_field, iconSize: 0.07, page: Livestock(farmId: farmId)),
                    verticalSpace(context, 0.011),
                    _selectionTile(text: 'Properties'.i18n, icon: CustomIcons.warehouse, iconSize: 0.06, page: Livestock(farmId: farmId)),
                    verticalSpace(context, 0.011),
                    _selectionTile(text: 'Staff'.i18n, icon: CustomIcons.users, iconSize: 0.065, page: Livestock(farmId: farmId)),
                    verticalSpace(context, 0.005),
                    Divider(),
                    verticalSpace(context, 0.005),
                    _selectionTile(text: 'Settings'.i18n, icon: Icons.settings, iconSize: 0.07, page: Livestock(farmId: farmId)),
                    verticalSpace(context, 0.011),
                    _selectionTile(text: 'Sign out'.i18n, icon: CustomIcons.sign_out_alt, iconSize: 0.065, page: Login(), onPressed: FirebaseAuthorization().signOut),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerHeader() {
    return Container(
      height: displayHeight(context) * 0.2,
      width: displayWidth(context) * 0.7,
      child: DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: [
                    imageThumbnail(
                        context: context,
                        size: 0.21,
                        color: primaryRed()),
                    horizontalSpace(context, 0.03),
                    Column(
                      children: [
                        verticalSpace(context, 0.02),
                        Text(FirebaseAuthorization().auth.currentUser.displayName,
                        style: GoogleFonts.notoSans(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: displayWidth(context) * 0.04),),
                        verticalSpace(context, 0.02),
                        SizedBox(
                          height: displayHeight(context) * 0.045,
                          width: displayWidth(context) * 0.4,
                          child: TextButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(primaryRed()),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.change_circle_outlined, color: Colors.white,),
                                Text(
                                  farmId,
                                  style: GoogleFonts.notoSans(color: Colors.white),),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _selectionTile({@required String text, @required IconData icon, @required double iconSize, @required page, Function onPressed}) {
    bool _isCurrent = _currentRoute == page.routeName;
    return  Container(
      width: displayWidth(context) * 0.68,
      height: displayWidth(context) * 0.12,
      child: RaisedButton(
        elevation: 0,
        color: _isCurrent? primaryRed() : Colors.grey[50],
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
            Container(
              height: displayWidth(context) * 0.1,
                width: displayWidth(context) * 0.1,
                child: Icon(icon, color: _isCurrent? Colors.white : primaryRed(), size: displayWidth(context) * iconSize)),
            horizontalSpace(context, 0.04),
            Text(
              text,
              style: GoogleFonts.notoSans(
                textStyle: TextStyle(color: _isCurrent? Colors.white : Colors.black38),
                fontSize: displayWidth(context) * 0.05,
                fontWeight: _isCurrent? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        onPressed: () {
          navigate(context: context, page: page, direction: 'bottom', fromDrawer: true);
          if (onPressed != null) {
            onPressed();
          }
        },
      ),
    );
  }

}