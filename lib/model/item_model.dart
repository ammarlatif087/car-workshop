class Item {
  late String id;
  late String name;
  late String description;
  late String totalqty;

  late String imageUrl;
  late double price;
  late String userId;

  Item({required this.name, required this.description});

  Item.fromJson(Map<dynamic, dynamic> data) {
    id = data['id'];
    name = data['name'];
    totalqty = data['totalqty'];
    description = data['description'];
    imageUrl = data['image_url'];
    userId = data['user_id'];
    price = data['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "id": id,
      "name": name,
      "totalqty": totalqty,
      "description": description,
      "price": price,
      "image_url": imageUrl,
    };
  }
}
