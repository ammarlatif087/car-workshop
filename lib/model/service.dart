class Service {
  late String name;
  late double rate;
  Service(this.name , this.rate);

  Service.fromJson(Map<dynamic, dynamic> data) {
    name = data['name'];
    rate = data['rate'].toDouble();
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "rate": rate};
  }
}
