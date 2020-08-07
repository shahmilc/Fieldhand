import 'package:fieldhand/central/livestock.dart';
import 'package:fieldhand/computation/navigation.dart';
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
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {

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
                    _selectionTile(text: 'Dashboard'.i18n, icon: Icons.view_list, iconSize: 0.09, page: Dashboard()),
                    verticalSpace(context, 0.011),
                   _selectionTile(text: 'Livestock'.i18n, icon: CustomIcons.horse, iconSize: 0.07, page: Livestock()),
                    verticalSpace(context, 0.011),
                    _selectionTile(text: 'Machinery'.i18n, icon: CustomIcons.tractor, iconSize: 0.065, page: Livestock()),
                    verticalSpace(context, 0.011),
                    _selectionTile(text: 'Fields'.i18n, icon: CustomIcons.crop_field, iconSize: 0.07, page: Livestock()),
                    verticalSpace(context, 0.011),
                    _selectionTile(text: 'Properties'.i18n, icon: CustomIcons.warehouse, iconSize: 0.06, page: Livestock()),
                    verticalSpace(context, 0.011),
                    _selectionTile(text: 'Staff'.i18n, icon: CustomIcons.users, iconSize: 0.065, page: Livestock()),
                    verticalSpace(context, 0.005),
                    Divider(),
                    verticalSpace(context, 0.005),
                    _selectionTile(text: 'Settings'.i18n, icon: Icons.settings, iconSize: 0.07, page: Livestock()),
                    verticalSpace(context, 0.011),
                    _selectionTile(text: 'Sign out'.i18n, icon: CustomIcons.sign_out_alt, iconSize: 0.065, page: Livestock()),
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
              imageThumbnail(
                  context: context,
                  size: 0.25,
                  color: primaryRed())
            ],
          )),
    );
  }

  Widget _selectionTile({@required String text, @required IconData icon, @required double iconSize, @required page}) {
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
                textStyle: TextStyle(color: _isCurrent? Colors.white : Colors.black54),
                fontSize: displayWidth(context) * 0.052,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        onPressed: () {
          navigate(context: context, page: page, direction: 'bottom', fromDrawer: true);
        },
      ),
    );
  }

}