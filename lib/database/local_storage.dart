import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<bool> storeData({@required String key, @required value}) async {
  if (value.runtimeType == String) {
    return await (await _prefs).setString(key, value);
  } else if (value.runtimeType == bool) {
    return await (await _prefs).setBool(key, value);
  } else if (value.runtimeType == int) {
    return await (await _prefs).setInt(key, value);
  } else {
    return false;
  }
}

getData({@required String key}) async {
  return (await _prefs).get(key);
}
