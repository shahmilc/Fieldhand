import 'package:flutter/material.dart';

Widget tapDetect({@required Widget child}) {
  return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child);
}