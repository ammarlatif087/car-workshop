import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/booking_model.dart';
import 'package:workshop/model/cart_model.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/model/order_model.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/utils/utils.dart';

class WorkshopOrderProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  WorkshopOrderProvider({required this.databaseReference});

  List<OrderModel> orders = [];

  void updateOrder(BuildContext context, OrderModel orderModel, String status) {
    orderModel.status = status;
    databaseReference.child(orderModel.id).set(orderModel.toJson());
    infoSnackBar(context, "Order $status Successfully");
    popWidget(context);
    popWidget(context);
    notifyListeners();
  }

  void getData() async {
    orders.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot = await databaseReference
        .orderByChild("workshop_id")
        .equalTo(getUserId())
        .get();
    dynamic data = dataSnapshot.value;
    if (data != null) {
      data.forEach((key, e) {
        orders.add(OrderModel.fromJson(e));
      });
    }

    print("Items${orders.length}");
    isLoading = false;

    notifyListeners();
  }
}
