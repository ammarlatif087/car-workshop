
import 'item_model.dart';

class CartModel {
  late String id;
  late Item item;
  late String userId;
  late String workshopId;
  late int qty;

  CartModel();

  CartModel.fromJson(Map<dynamic, dynamic> data) {
    id = data['id'];
    userId = data['user_id'];
    workshopId = data['workshop_id'];
    qty = data['qty'];
    item = Item.fromJson(data['item']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "qty": qty,
      'user_id': userId,
      'workshop_id': workshopId,
      'item': item.toJson()
    };
  }
}
