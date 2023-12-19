import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workshop/model/cart_model.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/model/order_model.dart';
import 'package:workshop/provider/user_order_provider.dart';
import 'package:workshop/utils/utils.dart';

class UserCartProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  UserCartProvider({required this.databaseReference});

  List<CartModel> carts = [];

  void placeOrder(BuildContext context, String proofUrl) {
    uploadFile(
      'attach',
      File(proofUrl),
      onSuccessCallback: (data) {
        OrderModel orderModel = OrderModel();
        orderModel.items = carts;
        orderModel.userId = getUserId();
        orderModel.workshopId = carts[0].workshopId;
        orderModel.date = getCurrentDate();
        orderModel.time = getCurrentTime();
        orderModel.status = "Pending";
        orderModel.proofUrl = data;
        getProvider<UserOrderProvider>(context).placeOrder(context, orderModel);
        for (var element in carts) {
          databaseReference.child(element.id).remove();
        }
        carts.clear();
        notifyListeners();
      },
      onErrorCallback: (onErrorCallback) {
        infoSnackBar(context, "Something went wrong");
      },
    );
  }

  List<Item> getItems() {
    List<Item> items = [];
    for (var element in carts) {
      items.add(element.item);
    }

    return items;
  }

  double getTotal() {
    double total = 0;

    for (var element in carts) {
      total += element.qty * element.item.price;
    }

    return total;
  }

  void addCart(BuildContext context, CartModel cartModel) {
    if (carts.isNotEmpty) {
      if (carts[0].item.userId != cartModel.item.userId) {
        infoSnackBar(context,
            "You can not add this warehouse item because of another warehouse item you are added");
        return;
      }
    }

    String key = databaseReference.push().key.toString();
    cartModel.id = key;
    databaseReference.child(key).set(cartModel.toJson());
    carts.add(cartModel);
    notifyListeners();
    infoSnackBar(context, "Add Into Cart Successfully");
  }

  void updateCart(CartModel cartModel) {
    databaseReference.child(cartModel.id).set(cartModel.toJson());
    notifyListeners();
  }

  CartModel? getCartItemByItemId(String itemId) {
    for (CartModel cartModel in carts) {
      if (cartModel.item.id == itemId) {
        return cartModel;
      }
    }
    return null;
  }

  void getData() async {
    carts.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot = await databaseReference
        .orderByChild("user_id")
        .equalTo(getUserId())
        .get();
    dynamic data = dataSnapshot.value;
    if (data != null) {
      data.forEach((key, e) {
        carts.add(CartModel.fromJson(e));
      });
    }

    print("Items${carts.length}");
    isLoading = false;

    notifyListeners();
  }
}
