import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workshop/model/service_schedule_model.dart';

import '../model/item_model.dart';
import '../model/user.dart';

class WorkshopDetailsProvider extends ChangeNotifier {
  DatabaseReference itemsReference;
  DatabaseReference scheduleReference;
  bool isLoading = false;
  bool isServicesLoading = false;

  late User workshop;

  void setWokShop(User workshop) {
    this.workshop = workshop;
    items.clear();
    services.clear();
  }

  WorkshopDetailsProvider({required this.itemsReference , required this.scheduleReference});

  List<Item> items = [];
  List<ServiceSchedule> services = [];

  void getItems() async {
    items.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot =
        await itemsReference.orderByChild("user_id").equalTo(workshop.id).get();

    dynamic data = dataSnapshot.value;

    if (data != null) {
      data.forEach((key, e) {
        items.add(Item.fromJson(e));
      });
    } else {}
    print("Workshops${items.length}");
    isLoading = false;
    notifyListeners();
  }
  void getServices() async {
    services.clear();
    isServicesLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot =
    await scheduleReference.orderByChild("user_id").equalTo(workshop.id).get();

    dynamic data = dataSnapshot.value;

    if (data != null) {
      data.forEach((key, e) {
        services.add(ServiceSchedule.fromJson(e));
      });
    } else {}
    print("Workshops${services.length}");
    isServicesLoading = false;
    notifyListeners();
  }
}
