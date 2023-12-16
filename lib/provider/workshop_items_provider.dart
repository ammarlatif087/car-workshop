import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/utils/utils.dart';

class WorkShopsItemsProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  WorkShopsItemsProvider({required this.databaseReference});

  List<Item> items = [];

  void addItem(BuildContext context, Item item, {required File file}) {
    String key = databaseReference.push().key.toString();

    showLoadingDialog("Please wait...");
    uploadFile(
      "Items",
      file,
      onSuccessCallback: (data) {
        item.id = key;
        item.imageUrl = data;
        databaseReference.child(key).set(item.toJson());
        infoSnackBar(context, "Item Saved Successfully");
        dismissLoadingDialog();
        items.add(item);
        notifyListeners();
        popWidget(context);
      },
      onErrorCallback: (error) {
        infoSnackBar(context, error);
        dismissLoadingDialog();
      },
    );
  }

  void updateItem(BuildContext context, Item item, {required File? file}) {
    showLoadingDialog("Please wait...");
    if (file != null) {
      uploadFile(
        "Items",
        file,
        onSuccessCallback: (data) {
          item.imageUrl = data;

          updateItemData(context, item);
        },
        onErrorCallback: (error) {
          infoSnackBar(context, error);
          dismissLoadingDialog();
        },
      );
    } else {
      updateItemData(context, item);
    }
  }

  void deleteItem(BuildContext context, Item item) {
    showLoadingDialog("Please wait...");
    databaseReference.child(item.id).remove().then((value) {
      infoSnackBar(context, "Item Deleted Successfully");
      dismissLoadingDialog();
      items.remove(item);
      notifyListeners();
      // getItems();
    });
  }

  void updateItemData(BuildContext context, Item item) {
    databaseReference.child(item.id).set(item.toJson());
    notifyListeners();
    dismissLoadingDialog();
    infoSnackBar(context, "Item Update Successfully");
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
