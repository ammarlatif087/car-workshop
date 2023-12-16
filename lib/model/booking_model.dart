import 'package:flutter/material.dart';
import 'package:workshop/model/service.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/utils/color_resources.dart';

class BookingModel {
  late String id;
  late ServiceSchedule serviceSchedule;
  late String selectedDay;
  late String userId;
  late String workshopId;
  late String bookingDate;
  late String bookingTime;
  late String status;

  String proofUrl = "";
  List<Service> services = [];

  BookingModel();

  Color getStatusColor() {
    if (status == "Pending") {
      return ColorResources.YELLOW;
    } else if (status == "Cancelled") {
      return ColorResources.RED;
    }
    return ColorResources.GREEN;
  }

  BookingModel.fromJson(Map<dynamic, dynamic> data) {
    id = data['id'];
    serviceSchedule = ServiceSchedule.fromJson(data['service_schedule']);
    selectedDay = data['selected_day'];
    userId = data['user_id'];
    workshopId = data['workshop_id'];
    bookingDate = data['booking_date'];
    bookingTime = data['booking_time'];
    proofUrl = data['proof_url'] ?? "";
    status = data['status'] ?? "Pending";

    if (data['services'] != null) {
      data['services'].forEach((e) {
        services.add(Service.fromJson(e));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "booking_date": bookingDate,
      "booking_time": bookingTime,
      'service_schedule': serviceSchedule.toJson(),
      'user_id': userId,
      'proof_url': proofUrl,
      'workshop_id': workshopId,
      'selected_day': selectedDay,
      'status': status,
      'services' : services.map((e) => e.toJson()).toList()
    };
  }
}
