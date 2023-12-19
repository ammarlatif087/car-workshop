import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/model/cart_model.dart';
import 'package:workshop/provider/user_cart_provider.dart';
import 'package:workshop/view/custom_image.dart';
import '../model/item_model.dart';
import '../utils/color_resources.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/utils.dart';

class ItemWidget extends StatefulWidget {
  final Item item;

  bool isSold;

  double? height, width;

  ItemWidget(
      {super.key,
      required this.item,
      this.width,
      this.height,
      this.isSold = false});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  // String wId = widget.item.userId;
  DatabaseReference starCountRef =
      FirebaseDatabase.instance.ref().child('Users');

  // List<Map<String, dynamic>> ingredientsList = [];
  List<String> ingredientsName = [];
  @override
  void initState() {
    super.initState();
    getUser(widget.item.userId);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 5,
        shape: getCardShape(20),
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          // padding: const EdgeInsets.symmetric(
          //     vertical: Dimensions.PADDING_SIZE_SMALL),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomImage(
                image: widget.item.imageUrl,
                height: getScreenWidth(context) / 3,
                width: getScreenWidth(context),
                isCircleImage: false),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: Text(
                widget.item.name,
                style: titleRegular.copyWith(color: ColorResources.BLACK),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: Text(
                widget.item.description,
                style: titleRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    color: ColorResources.GRAY),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: Text(
                "Rs: ${widget.item.price}",
                style: titleRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    fontWeight: FontWeight.bold,
                    color: ColorResources.BLACK),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Consumer<UserCartProvider>(
              builder: (context, value, child) {
                CartModel? cartModel =
                    value.getCartItemByItemId(widget.item.id);

                return cartModel == null
                    ? Center(
                        child: InkWell(
                          onTap: () {
                            CartModel cartModel = CartModel();
                            cartModel.item = widget.item;
                            cartModel.userId = getUserId();
                            cartModel.workshopId = widget.item.userId;
                            cartModel.qty = 1;
                            getProvider<UserCartProvider>(context)
                                .addCart(context, cartModel);
                          },
                          child: Chip(
                            label: Text(
                              "Add Cart",
                              style: titleRegular.copyWith(
                                  color: ColorResources.WHITE),
                            ),
                            backgroundColor: getPrimaryColor(context),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: getWidthMargin(context, 5),
                                vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      if (cartModel.qty == 1) {
                                        return;
                                      }

                                      cartModel.qty = cartModel.qty - 1;
                                      value.updateCart(cartModel);
                                    },
                                    backgroundColor: getPrimaryColor(context),
                                    child: const Icon(Icons.remove),
                                  ),
                                ),
                                Text(cartModel.qty.toString()),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      cartModel.qty = cartModel.qty + 1;
                                      value.updateCart(cartModel);
                                    },
                                    backgroundColor: getPrimaryColor(context),
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            itemCount: ingredientsName.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Ac/No\nEasypaisa/JazzCash',
                                      style: titleRegular,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(ingredientsName[index]),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
              },
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> getUser(String userId) async {
    starCountRef
        .orderByChild('id')
        .equalTo(userId)
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        Map<String, dynamic> userMap =
            Map<String, dynamic>.from(data.cast<String, dynamic>());
        List<Map<String, dynamic>> userList = [];

        userMap.forEach((key, value) {
          Map<String, dynamic> userData = Map<String, dynamic>.from(value);

          // Check if the user has the role 'workshop'
          if (userData['role'] == 'Workshop') {
            userList.add(userData);
          }
        });

        setState(() {
          ingredientsName =
              userList.map((user) => user['acno'] as String).toList();

          print(ingredientsName);
        });
      }
    });
  }
}
