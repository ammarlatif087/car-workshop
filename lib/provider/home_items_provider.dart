import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/utils/utils.dart';

class HomeItemsProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  HomeItemsProvider({required this.databaseReference});

  List<Item> items = [];

  void getData() async {
    items.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot = await databaseReference.get();

    dynamic data = dataSnapshot.value;
    if (data != null) {
      data.forEach((key, e) {
        items.add(Item.fromJson(e));
      });
    }

    print("Items${items.length}");
    isLoading = false;

    notifyListeners();
  }
}
