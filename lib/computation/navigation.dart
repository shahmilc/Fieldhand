import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fieldhand/database/globals.dart' as globals;
import 'package:fieldhand/computation/transitions.dart';

void navigate({@required BuildContext context, @required page, @required String direction, @required bool fromDrawer, bool replace = false, bool pop = false}) {
  if (globals.routeStack.isEmpty || page.routeName != globals.routeStack.last) {
    if (fromDrawer) Navigator.pop(context);
    if (direction == 'bottom') {
      if (pop) {
        Navigator.pushAndRemoveUntil(context, SlideBottomRoute(page: page), (route) => false);
      } else if (replace) {
        Navigator.pushReplacement(context, SlideBottomRoute(page: page));
      } else {
        Navigator.push(context, SlideBottomRoute(page: page));
      }
    } else if (direction == 'right') {
      if (pop) {
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => page), (route) => false);
      } else if (replace) {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => page));
      } else {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
      }
    }
    _setCurrentRoute(routeName: page.routeName, replace: replace, pop: pop);
  } else {
    if (fromDrawer) Navigator.pop(context);
  }
  print("Stack: ${globals.routeStack}");
}

void _setCurrentRoute({@required String routeName, @required bool replace, @required bool pop}) {
  if (globals.routeStack.isEmpty || globals.routeStack.last != routeName) {
    if (replace || pop) globals.routeStack.removeLast();
    if (!pop) globals.routeStack.add(routeName);
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