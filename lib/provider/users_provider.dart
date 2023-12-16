import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workshop/utils/utils.dart';

import '../main.dart';
import '../model/user.dart';

class UsersProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  UsersProvider({required this.databaseReference});

  List<User> users = [];

  void updateUserStatus(BuildContext context, User user, String status) {
    user.status = status;
    databaseReference.child(user.id).set(user.toJson());
    infoSnackBar(
        context, (user.role == "User" ? "User " : "Workshop ") + status);
    notifyListeners();
    popWidget(context);
  }

  void getUsers(String role) async {
    users.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot =
        await databaseReference.orderByChild("role").equalTo(role).get();

    dynamic data = dataSnapshot.value;

    if (data == null) {
    } else {
      data.forEach((key, e) {
        User user = User.fromJson(e);
        user.id = key;
        users.add(user);
      });
    }
    print("Items${users.length}");
    isLoading = false;
    notifyListeners();
  }
}
