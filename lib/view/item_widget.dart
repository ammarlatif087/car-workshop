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

class ItemWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 5,
        shape: getCardShape(20),
        child: SizedBox(
          height: height,
          width: width,
          // padding: const EdgeInsets.symmetric(
          //     vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Stack(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CustomImage(
                    image: item.imageUrl,
                    height: getScreenWidth(context) / 3,
                    width: getScreenWidth(context),
                    isCircleImage: false),
                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Text(
                    item.name,
                    style: titleRegular.copyWith(color: ColorResources.BLACK),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Text(
                    item.description,
                    style: titleRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        color: ColorResources.GRAY),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Text(
                    "Rs: ${item.price}",
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
                    CartModel? cartModel = value.getCartItemByItemId(item.id);

                    return cartModel == null
                        ? Center(
                            child: InkWell(
                              onTap: () {
                                CartModel cartModel = CartModel();
                                cartModel.item = item;
                                cartModel.userId = getUserId();
                                cartModel.workshopId = item.userId;
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
                        : Container(
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
                                )
                              ],
                            ),
                          );
                  },
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
