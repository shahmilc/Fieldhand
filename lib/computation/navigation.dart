import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/database/globals.dart' as globals;
import 'package:fieldhand/computation/transitions.dart';

void navigate({@required BuildContext context, @required page, @required String direction, @required bool fromDrawer}) {
  if (globals.routeStack.isEmpty || page.routeName != globals.routeStack.last) {
    if (fromDrawer) Navigator.pop(context);
    if (direction == 'bottom') {
      Navigator.push(context, SlideBottomRoute(page: page));
    } else if (direction == 'right') {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
    }
    setCurrentRoute(routeName: page.routeName);
  } else {
    if (fromDrawer) Navigator.pop(context);
  }
  print("Stack: ${globals.routeStack}");
}

void setCurrentRoute({@required String routeName}) {
  if (globals.routeStack.isEmpty || globals.routeStack.last != routeName) globals.routeStack.add(routeName);
}

Future<bool> onBackPress({@required BuildContext context}) async {
  print("BACK");
  print(globals.routeStack);
  if (!globals.isDrawerOpen) globals.routeStack.removeLast();
  Navigator.pop(context);
  print(globals.routeStack);
  return true;
}