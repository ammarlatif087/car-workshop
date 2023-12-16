import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';

class WorkshopsProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  WorkshopsProvider({required this.databaseReference});

  List<User> workshops = [];

  void getItems() async {
    workshops.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot =
        await databaseReference.orderByChild("role").equalTo("Workshop").get();

    dynamic data = dataSnapshot.value;

    if (data != null) {
      data.forEach((key, e) {
        workshops.add(User.fromJson(e));
      });
    } else {}
    print("Workshops${workshops.length}");
    isLoading = false;
    notifyListeners();
  }
}
