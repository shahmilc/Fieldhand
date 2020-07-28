import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  return displaySize(context).height - kToolbarHeight;
}

double displayWidth(BuildContext context) {
  return displaySize(context).width;
}

Widget verticalSpace(BuildContext context, double factor) {
  return SizedBox(
    height: displayHeight(context) * factor,
  );
}

Widget horizontalSpace(BuildContext context, double factor) {
  return SizedBox(
    width: displayWidth(context) * factor,
  );
}