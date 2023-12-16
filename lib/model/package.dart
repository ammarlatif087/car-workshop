class Package {
  late int id;
  late String title;
  late double rate;
  late int days;
  String? status;
  String? startDate;
  String? endDate;
  String? attachment;
  String? userId;

  Package(
      {required this.title,
      required this.rate,
      required this.days,
      required this.id});

  Package.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    rate = json['rate'].toDouble();
    title = json['title'];
    days = json['days'];
    userId = json['user_id'];
    attachment = json['attachment'];
    status = json['status'] ?? "Pending";
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "rate": rate,
      "days": days,
      "user_id": userId,
      "status": status,
      "attachment": attachment,
      "start_date": startDate,
      "end_date": endDate,
    };
  }
}
