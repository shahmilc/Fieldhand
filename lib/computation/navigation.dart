import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/database/globals.dart' as globals;
import 'package:fieldhand/computation/transitions.dart';

void navigate({@required BuildContext context, @required page, @required String direction, @required bool fromDrawer, bool replace = false}) {
  if (globals.routeStack.isEmpty || page.routeName != globals.routeStack.last) {
    if (fromDrawer) Navigator.pop(context);
    if (direction == 'bottom') {
      if (replace) {
        Navigator.pushReplacement(context, SlideBottomRoute(page: page));
      } else {
        Navigator.push(context, SlideBottomRoute(page: page));
      }
    } else if (direction == 'right') {
      if (replace) {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => page));
      } else {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
      }
    }
    _setCurrentRoute(routeName: page.routeName, replace: replace);
  } else {
    if (fromDrawer) Navigator.pop(context);
  }
  print("Stack: ${globals.routeStack}");
}

void _setCurrentRoute({@required String routeName, @required bool replace}) {
  if (globals.routeStack.isEmpty || globals.routeStack.last != routeName) {
    if (replace) globals.routeStack.removeLast();
    globals.routeStack.add(routeName);
  }
}

Future<bool> onBackPress({@required BuildContext context}) async {
  print("BACK");
  print(globals.routeStack);
  if (!globals.isDrawerOpen) globals.routeStack.removeLast();
  Navigator.pop(context);
  print(globals.routeStack);
  return true;
}