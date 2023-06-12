import 'dart:math';
import 'dart:io';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';
import 'package:fieldhand/extentions/string_extensions.dart';
import 'package:english_words/english_words.dart';

/// Generate object random serial code
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String generateObjectSerial() => '${String.fromCharCodes(Iterable.generate(
    15, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))))}${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

/// Convert Iso8601String to locale specific date format
String convertDate(String date) {
  try {
    return DateFormat.yMMMd(I18n.locale.toString()).format(
        DateTime.parse(date));
  } catch(e) {
    return date;
  }
}

/// Get image name from image address
String getImageName(String address) {
  String name = address.split('.')[0].split('/').last.capitalize();
  return (name.length > 10 || name == 'Com')? 'Custom' : name;
}

/// Check for internet connection
Future<bool> checkNet() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}

/// Generate random short ID
String generateShortId() {
  String id = '${String.fromCharCodes(Iterable.generate(8, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))))}'.toUpperCase();
  return id;
}


