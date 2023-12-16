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

class WorkshopBookingsProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  WorkshopBookingsProvider({required this.databaseReference});

  List<BookingModel> bookings = [];

  void updateBooking(
      BuildContext context, BookingModel orderModel, String status) {
    orderModel.status = status;
    databaseReference.child(orderModel.id).set(orderModel.toJson());
    infoSnackBar(context, "Booking $status Successfully");
    popWidget(context);
    popWidget(context);
    notifyListeners();
  }

  void getData() async {
    bookings.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot = await databaseReference
        .orderByChild("workshop_id")
        .equalTo(getUserId())
        .get();
    dynamic data = dataSnapshot.value;
    if (data != null) {
      data.forEach((key, e) {
        bookings.add(BookingModel.fromJson(e));
      });
    }

    print("Items${bookings.length}");
    isLoading = false;

    notifyListeners();
  }
}
