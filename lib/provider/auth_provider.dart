import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workshop/main.dart';
import 'package:workshop/screen/splash_screen.dart';
import 'package:workshop/screen/user_dashboard_screen.dart';
import 'package:workshop/screen/workshop_dashboard_screen.dart';
import 'package:workshop/utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  User? user;
  final USERS = "Users";

  void loginUser(String email, String pass) {}

  void signUpUser(
    BuildContext context, {
    required String email,
    required String password,
    required String name,
    File? file,
    String address = "",
  }) async {
    showLoadingDialog("Please Wait...");
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Map<String, dynamic> json = {
        "email": email,
        "password": password,
        "address": address,
        "role": "User",
        "name": name,
      };

      uploadFile(
        "Users",
        file!,
        onSuccessCallback: (data) {
          json['image_url'] = data;
          saveUserData(context, json, credential.user!.uid);
        },
        onErrorCallback: (error) {
          infoSnackBar(context, error);
          dismissLoadingDialog();
        },
      );
    } catch (e) {
      infoSnackBar(context, e.toString());
      dismissLoadingDialog();
    }
  }

  void saveUserData(
      BuildContext context, Map<dynamic, dynamic> json, String key) {
    DatabaseReference databaseReference = firebaseDatabase.ref(USERS);
    // String key = credential.user!.uid;
    // json['id'] = key;
    databaseReference.child(key).set(json);
    infoSnackBar(context, "Register Successfully");
    pushUntil(
        context,
        json['role'] == 'Workshop'
            ? const WorkShopDashboardWidget()
            : const UserDashboardWidget());

    dismissLoadingDialog();
  }

  void signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      showLoadingDialog("Please wait...");
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      dismissLoadingDialog();
      if (credential.user != null) {
        pushUntil(context, SplashScreen());
      } else {
        infoSnackBar(context, "User not exist ");
      }
      dismissLoadingDialog();
    } catch (e) {
      infoSnackBar(context, e.toString());
      dismissLoadingDialog();
    }
  }

  void signUpWorkShop(
    BuildContext context, {
    required String email,
    required String password,
    required String name,
    required String cnic,
    required String bName,
    required String acno,
    File? file,
    String address = "",
  }) async {
    showLoadingDialog("Please Wait...");
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Map<String, dynamic> json = {
        "email": email,
        'id': credential.user!.uid,
        "password": password,
        "role": "Workshop",
        "address": address,
        "name": name,
        "bName": bName,
        "acno": acno,
        "cnic": cnic,
      };

      uploadFile(
        "Users",
        file!,
        onSuccessCallback: (data) {
          json['image_url'] = data;
          saveUserData(context, json, credential.user!.uid);
        },
        onErrorCallback: (error) {
          infoSnackBar(context, error);
          dismissLoadingDialog();
        },
      );
    } catch (e) {
      infoSnackBar(context, e.toString());
      dismissLoadingDialog();
    }
  }
}
