import 'dart:convert';
import 'package:fieldhand/central/dashboard.dart';
import 'package:fieldhand/connectivity/auth_connection.dart';
import 'package:fieldhand/database/firebase_core.dart';
import 'package:fieldhand/database/local_storage.dart';
import 'package:fieldhand/start_up/create_profile.dart';
import 'package:fieldhand/start_up/farm/farm_selection.dart';
import 'package:fieldhand/start_up/language_selection.dart';
import 'package:fieldhand/start_up/login.dart';
import 'package:flutter/material.dart';

Future<Widget> findStartScreen() async {
  return (() async {
    if (FirebaseAuthorization().isSignedIn()) {
      if (await FirebaseCore().checkUserProfileExists(email: FirebaseAuthorization().auth.currentUser.email)) {
        if (json.decode(await FirebaseCore().getUserField(field: 'farms_owned')).isNotEmpty) {
          return Dashboard(farmId: (await FirebaseCore().retrieveFarms()).first);
        } else if (json.decode(await FirebaseCore().getUserField(field: 'farms_joined')).isNotEmpty) {
          return Dashboard(farmId: (await FirebaseCore().retrieveFarms()).first);
        } else {
          return FarmSelection();
        }
      } else {
        return CreateProfile();
      }
    } else if ((await getData(key: 'welcomed')) == true) {
      return Login();
    } else {
      return LanguageSelection();
    }
  })();
}