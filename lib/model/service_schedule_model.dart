import 'dart:convert';

import 'package:workshop/model/service.dart';
import 'package:workshop/utils/utils.dart';

class ServiceSchedule {
  late String id;
  late String modelNo;
  late String userId;
  late String startTime;
  late String endTime;
  late List<dynamic> days;
  late List<dynamic> services = [];

  late List<Service> servicesV2 = [];

  String getDuration() {
    return "${getUserFormattedTime(startTime)} to ${getUserFormattedTime(endTime)}";
  }

  ServiceSchedule(
      {required this.modelNo,
      required this.startTime,
      required this.endTime,
      required this.days,
      required this.services});

  ServiceSchedule.fromJson(Map<dynamic, dynamic> data) {
    id = data['id'];
    modelNo = data['model_no'];
    userId = data['user_id'];
    startTime = data['start_time'];
    endTime = data['end_time'];
    days = jsonDecode(data['days']);
    // services = jsonDecode(data['services']);
    List<Service> services = [];

    if( data['services_v2'] != null){

      data['services_v2'].forEach((e){
        services.add(Service.fromJson(e));
      });
    }

    servicesV2.addAll(services);
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "days": jsonEncode(days),
      "services": jsonEncode(services),
      'start_time': startTime,
      'end_time': endTime,
      "id": id,
      "model_no": modelNo,
      "services_v2": servicesV2.map((e) => e.toJson()).toList(),
    };
  }
}
