class User {
  late String id;
  late String name;
  late String imageUrl;
  late String address;
  late String dateOfBirth;
  late String email;
  late String role;
  String? status;
  late String password;
  late String bname;
  late String acno;
  late String cnic;

  User(
      {required this.id,
      required this.name,
      required this.cnic,
      required this.acno,
      required this.bname,
      required this.imageUrl,
      this.email = "",
      this.password = "",
      required this.address,
      required this.dateOfBirth});

  User.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    imageUrl = json['image_url'] ?? "";
    email = json['email'];
    role = json['role'];
    password = json['password'].toString();
    address = json['address'] ?? "";
    status = json['status'] ?? "Pending";
    acno = json['acno'] ?? "";
    bname = json['bName'] ?? "";
    cnic = json['cnic'] ?? "";
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image_url": imageUrl,
      "address": address,
      "email": email,
      "status": status,
      "password": password,
      "acno": acno,
      "bName": bname,
      "cnic": cnic,
      "role": role,
    };
  }
}
