import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:workshop/main.dart';
import 'package:workshop/utils/utils.dart';

import '../model/user.dart';

class ProfileProvider extends ChangeNotifier {
  User? user;

  void updateUser(
      BuildContext context, String name, String address, File? file) {
    user!.name = name;
    user!.address = address;
    showLoadingDialog("Please wait...");
    if (file != null) {
      uploadFile(
        "Users",
        file,
        onSuccessCallback: (data) {
          user!.imageUrl = data;
          updateData(context);
        },
        onErrorCallback: (error) {
          infoSnackBar(context, error);
          dismissLoadingDialog();
        },
      );
      return;
    }
    updateData(context);
  }

  void updateData(BuildContext context) {
    firebaseDatabase.ref("Users").child(getUserId()).set(user!.toJson());
    notifyListeners();
    dismissLoadingDialog();
    popWidget(context);
  }

  void getUser() async {
    DataSnapshot dataSnapshot =
        await firebaseDatabase.ref("Users").child(getUserId()).get();

    Map<dynamic, dynamic>? json = dataSnapshot.value as Map?;
    if (json != null) {
      user = User.fromJson(json);
    }
    notifyListeners();
  }
}
