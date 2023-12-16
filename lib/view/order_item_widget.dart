import 'package:flutter/material.dart';

import 'package:workshop/utils/custom_style.dart';
import '../model/cart_model.dart';
import '../utils/color_resources.dart';

import '../utils/dimensions.dart';
import '../utils/utils.dart';
import 'custom_image.dart';

class OrderItemWidget extends StatelessWidget {
  final CartModel item;

  double? height, width;

  OrderItemWidget({super.key, required this.item, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getWidthMargin(context, 1),
      ),
      child: InkWell(
        onTap: () {},
        child: Row(children: [
          const SizedBox(
            width: Dimensions.MARGIN_SIZE_SMALL,
          ),
          CustomImage(
            image: item.item.imageUrl,
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: Dimensions.MARGIN_SIZE_SMALL),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: SizedBox(
                  width: 200,
                  child: Text(
                    item.item.name,
                    style: titleHeader.copyWith(color: ColorResources.BLACK),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.PADDING_SIZE_DEFAULT, right: 5),
                    child: Text(
                      "X ${item.qty}",
                      style: titleRegular.copyWith(
                          color: ColorResources.DARK_GREY.withOpacity(0.7)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Text(
                      "Rs: ${item.item.price}",
                      style: titleRegular.copyWith(
                          color: ColorResources.DARK_GREY.withOpacity(0.7)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: Text(
                  "Total: ${item.qty * item.item.price}",
                  style: titleRegular.copyWith(color: ColorResources.DARK_GREY),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
