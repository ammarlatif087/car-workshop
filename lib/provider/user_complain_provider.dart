import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/booking_model.dart';
import 'package:workshop/model/cart_model.dart';
import 'package:workshop/model/complaint.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/model/order_model.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/utils/utils.dart';

class UserComplainProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  UserComplainProvider({required this.databaseReference});

  List<Complaint> complaints = [];

  void addComplain(BuildContext context, Complaint complaint) {
    String key = databaseReference.push().key.toString();
    complaint.id = key;
    databaseReference.child(key).set(complaint.toJson());
    infoSnackBar(context, "Complaint Added Successfully");
    complaints.add(complaint);
    notifyListeners();
  }

  void update(BuildContext context, Complaint complaint, String status) {
    complaint.status = status;
    databaseReference.child(complaint.id).set(complaint.toJson());
    infoSnackBar(context, "Complaint $status");
    notifyListeners();
    popWidget(context);
  }

  void getData({bool forUser = true}) async {
    complaints.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot = forUser
        ? await databaseReference
            .orderByChild("user_id")
            .equalTo(getUserId())
            .get()
        : await databaseReference.get();
    dynamic data = dataSnapshot.value;
    if (data != null) {
      data.forEach((key, e) {
        complaints.add(Complaint.fromJson(e));
      });
    }

    print("Items${complaints.length}");
    isLoading = false;

    notifyListeners();
  }
}
