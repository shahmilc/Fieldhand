import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class FirebaseAuthorization {

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> register({@required String email, @required String password}) async {
    final User user = (await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;

    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword({@required String email, @required String password}) async {
    final User user = (await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).user;

    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isSignedIn() {
    return auth.currentUser != null;
  }

  void signOut() {
    auth.signOut();
  }

}