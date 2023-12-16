import 'package:flutter/material.dart';
import 'package:workshop/model/cart_model.dart';
import 'package:workshop/utils/color_resources.dart';

class OrderModel {
  late String id;
  late List<CartModel> items;
  late String userId;
  late String workshopId;
  late String date;
  late String time;
  late String status;
  late String paymentType;

  OrderModel();

  Color getColorOfStatus() {
    if (status == "Pending") {
      return ColorResources.YELLOW;
    } else if (status == "Denied") {
      return ColorResources.RED;
    }
    return ColorResources.GREEN;
  }

  double getTotal() {
    double total = 0;
    for (var value in items) {
      total += value.qty * value.item.price;
    }
    return total;
  }

  OrderModel.fromJson(Map<dynamic, dynamic> data) {
    id = data['id'];
    userId = data['user_id'];
    workshopId = data['workshop_id'];
    date = data['date'];
    status = data['status'];
    time = data['time'];
    paymentType = data['paymentType'];

    items = [];

    data['items'].forEach((e) {
      items.add(CartModel.fromJson(e));
    });
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "date": date,
      "time": time,
      "status": status,
      'user_id': userId,
      'workshop_id': workshopId,
      'paymentType': paymentType,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
