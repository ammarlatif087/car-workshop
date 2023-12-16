import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/utils/utils.dart';

class HomeServicesProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  HomeServicesProvider({required this.databaseReference});

  List<ServiceSchedule> services = [];



  void getData() async {
    services.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot = await databaseReference
        .get();

    dynamic data = dataSnapshot.value;
    if (data != null) {
      data.forEach((key, e) {
        services.add(ServiceSchedule.fromJson(e));
      });
    }

    print("Items${services.length}");
    isLoading = false;

    notifyListeners();
  }
}
