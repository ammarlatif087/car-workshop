import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/model/package.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/screen/package_approval_screen.dart';
import 'package:workshop/screen/workshop_dashboard_screen.dart';
import 'package:workshop/utils/utils.dart';

class SubscriptionProvider extends ChangeNotifier {
  DatabaseReference databaseReference;

  SubscriptionProvider({required this.databaseReference});

  List<Package> subscription = [];

  Package? package;
  bool isLoading = false;

  void getPendingSubscriptions() async {
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot =
        await databaseReference.orderByChild("status").equalTo("Pending").get();

    Map<dynamic, dynamic>? json = dataSnapshot.value as Map<dynamic, dynamic>?;
    subscription.clear();

    print(json.toString());
    if (json != null) {
      json.forEach((key, value) {
        subscription.add(Package.fromJson(value));
      });
    }
    isLoading = false;
    notifyListeners();
  }

  void updatePackage(BuildContext context, Package package, String status) {
    package.status = status;
    databaseReference.child(package.userId.toString()).set(package.toJson());
    infoSnackBar(context, "Subscription $status");
    popWidget(context);
    popWidget(context);
    subscription.remove(package);
    notifyListeners();
  }

  void subscribePackage(
      BuildContext context, Package package, String selectedImage) {
    showLoadingDialog("Please wait...");
    uploadFile(
      "Attachments",
      File(selectedImage),
      onSuccessCallback: (data) {
        Map<dynamic, dynamic> packageJson = package.toJson();
        packageJson['start_date'] = getCurrentDate();
        packageJson['status'] = "Pending";
        packageJson['user_id'] = getUserId();
        packageJson['attachment'] = data;
        packageJson['end_date'] = getCurrentDate(nextDays: package.days);
        databaseReference.child(getUserId()).set(packageJson);

        dismissLoadingDialog();
        popWidget(context);
        pushUntil(context, PackageApprovalScreen(packageJson));
      },
      onErrorCallback: (error) {
        dismissLoadingDialog();
        infoSnackBar(context, error);
      },
    );
  }
}
