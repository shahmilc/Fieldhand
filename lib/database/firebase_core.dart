import 'package:fieldhand/computation/general_functions.dart';
import 'package:fieldhand/connectivity/auth_connection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCore {
  CollectionReference farms = FirebaseFirestore.instance.collection('farms');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference livestock = FirebaseFirestore.instance.collection('test')
      .doc('GUMCHQKY')
      .collection('livestock');

  /// User creation/management functions

  Future<bool> addUser(
      {@required String firstName, @required String lastName}) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(FirebaseAuthorization().auth.currentUser.email)
        .set({
      'name_first': firstName,
      'name_last': lastName,
      'farms_owned': json.encode([]),
      'farms_joined': json.encode([])
    })
        .then((value) {
      FirebaseAuthorization().auth.currentUser.updateProfile(
          displayName: "$firstName $lastName");
      return true;
    })
        .catchError((error) => false);
  }

  Future<bool> linkUserFarm(
      {@required String farmId, @required bool owned}) async {
    List farmList = json.decode(
        await getUserField(field: owned ? 'farms_owned' : 'farms_joined'));
    farmList.add(farmId);
    String newFarmList = json.encode(farmList);
    return users
        .doc(FirebaseAuthorization().auth.currentUser.email)
        .update({
      (owned ? 'farms_owned' : 'farms_joined'): newFarmList
    })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> checkUserProfileExists({@required String email}) {
    return users.doc(email).get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.exists ? true : false;
    });
  }

  Future<bool> checkFarmExists({@required String farmId}) {
    return farms.doc(farmId).get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.exists ? true : false;
    });
  }

  Future<String> getUserField({@required String field}) async {
    return users.doc(FirebaseAuthorization().auth.currentUser.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.get(field);
    });
  }

  Future<String> uniqueId() {
    String id = generateShortId();
    return farms.doc(id).get().then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.exists ? uniqueId() : id;
    });
  }

  Future<bool> createFarm({@required String farmName, @required String country}) async {
    String farmId = await uniqueId();
    return farms
        .doc(farmId)
        .set({
      'farm_name': farmName,
      'country': country,
      'owner_id': FirebaseAuthorization().auth.currentUser.email,
      'members_id': json.encode([]),
      'premium': false,
    })
        .then((value) => linkUserFarm(farmId: farmId, owned: true))
        .catchError((error) => false);
  }

  Future<List> retrieveFarms() async {
    List farmList = json.decode(await getUserField(field: 'farms_owned'));
    farmList.addAll(json.decode(await getUserField(field: 'farms_joined')));
    return farmList;
  }

  /// Farm database management functions

  insertObject({@required String farmId, @required String objectTable, @required object}) async {
    Map objectMap = object.toMap();
    objectMap.forEach((key, value) {
      farms.doc(farmId).collection(objectTable).doc(objectMap['name_id'])
          .update({
        key: value,
      });
    });
  }

  retrieveDataOptions({@required String farmId, @required String objectTable, @required String option, @required List defaults}) async {
    return farms.doc(farmId)
        .collection(objectTable)
        .doc('dataOptions')
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.data() == null || !documentSnapshot.data().containsKey(option)) {
            print(documentSnapshot.data());
            farms.doc(farmId)
                .collection(objectTable)
                .doc('dataOptions')
                .set({
              option: json.encode(defaults)
            }).then((value) {return retrieveDataOptions(farmId: farmId, objectTable: objectTable, option: option, defaults: defaults);});
          } else {
            return await (json.decode(documentSnapshot.get(option))).toSet();
          }
        });
  }
}
