import 'package:flutter/material.dart';
import 'package:workshop/utils/color_resources.dart';

class Complaint {
  late String id;
  late String userId;
  late String status;
  late String title;
  late String message;

  Complaint();

  Complaint.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    status = json['status'];
    title = json['title'];
    message = json['message'];
  }

  Color getColor() {
    if (status == "Pending") {
      return ColorResources.YELLOW;
    } else if (status == "Rejected") {
      return ColorResources.RED;
    } else {
      return ColorResources.GREEN;
    }
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "status": status,
      "title": title,
      "message": message,
    };
  }
}
