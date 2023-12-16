import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workshop/model/order_model.dart';
import 'package:workshop/utils/utils.dart';

class UserOrderProvider extends ChangeNotifier {
  DatabaseReference databaseReference;
  bool isLoading = false;

  UserOrderProvider({required this.databaseReference});

  List<OrderModel> orders = [];

  void placeOrder(BuildContext context, OrderModel orderModel) {
    String key = databaseReference.push().key.toString();
    orderModel.id = key;
    databaseReference.child(key).set(orderModel.toJson());
    infoSnackBar(context, "Order Placed");
    orders.add(orderModel);
    notifyListeners();
  }

  void getData() async {
    orders.clear();
    isLoading = true;
    notifyListeners();
    DataSnapshot dataSnapshot = await databaseReference
        .orderByChild("user_id")
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
