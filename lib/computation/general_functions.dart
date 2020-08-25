import 'dart:math';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';
import 'package:fieldhand/extentions/string_extensions.dart';

// Generate object random serial code
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String generateObjectSerial() => String.fromCharCodes(Iterable.generate(
    15, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

// Convert Iso8601String to locale specific date format
String convertDate(String date) {
  try {
    return DateFormat.yMMMd(I18n.locale.toString()).format(
        DateTime.parse(date));
  } catch(e) {
    return date;
  }
}

// Get image name from image address
String getImageName(String address) {
  String name = address.split('.')[0].split('/').last.capitalize();
  return (name.length > 10 || name == 'Com')? 'Custom' : name;
}



