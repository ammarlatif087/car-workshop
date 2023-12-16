import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/utils/utils.dart';

class VehiclesProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  VehiclesProvider({required this.databaseReference});

  List<ServiceSchedule> items = [];

  void addVehicle(BuildContext context, ServiceSchedule item) {
    String key = databaseReference.push().key.toString();

    showLoadingDialog("Please wait...");
    item.id = key;
    databaseReference.child(key).set(item.toJson());
    infoSnackBar(context, "Vehicle Model Saved Successfully");
    dismissLoadingDialog();
    items.add(item);
    notifyListeners();
    popWidget(context);
  }

  void updateVehicle(BuildContext context, ServiceSchedule item) {
    showLoadingDialog("Please wait...");

    databaseReference.child(item.id).set(item.toJson());
    infoSnackBar(context, "Vehicle Model Update Successfully");
    dismissLoadingDialog();
    // items.add(item);
    notifyListeners();
    popWidget(context);
  }

  void updateItem(BuildContext context, ServiceSchedule item) {
    showLoadingDialog("Please wait...");
    updateItemData(context, item);
  }

  void updateItemData(BuildContext context, ServiceSchedule item) {
    databaseReference.child(item.id).set(item.toJson());
    notifyListeners();
    dismissLoadingDialog();
    infoSnackBar(context, "Vehicle Model Update Successfully");
    popWidget(context);
  }

  void getItems() async {
    items.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot = await databaseReference
        .orderByChild("user_id")
        .equalTo(getUserId())
        .get();

    dynamic data = dataSnapshot.value;

    if (data == null) {
    } else {
      data.forEach((key, e) {
        items.add(ServiceSchedule.fromJson(e));
      });
    }
    print("Items${items.length}");
    isLoading = false;
    notifyListeners();
  }
}
