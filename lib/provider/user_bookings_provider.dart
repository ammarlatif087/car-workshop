import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/booking_model.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/utils/utils.dart';

class UserBookingsProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  UserBookingsProvider({required this.databaseReference});

  List<BookingModel> bookings = [];

  void addBooking(
      BuildContext context, BookingModel bookingModel, String selectedImage) {

    showLoadingDialog("Please Wait...");
    uploadFile(
      "Attachment",
      File(selectedImage),
      onSuccessCallback: (data) {
        bookingModel.proofUrl = data;
        String key = databaseReference.push().key.toString();
        bookingModel.id = key;
        bookingModel.status = "Pending";
        databaseReference.child(key).set(bookingModel.toJson());
        bookings.add(bookingModel);
        notifyListeners();
        infoSnackBar(context, "Booking Successfully Add");
        // popWidget(context);
        popWidget(context);
        popWidget(context);
        dismissLoadingDialog();
      },
      onErrorCallback: (error) {
        // popWidget(context);
        dismissLoadingDialog();
        infoSnackBar(context, error.toString());
      },
    );
  }

  void getData() async {
    bookings.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot = await databaseReference
        .orderByChild("user_id")
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
