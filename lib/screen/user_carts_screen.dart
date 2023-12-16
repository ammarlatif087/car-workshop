import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/provider/user_cart_provider.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/item_grid_view.dart';
import 'package:workshop/view/loader_view.dart';

import '../model/user.dart';

class UserCartsScreen extends StatefulWidget {
  const UserCartsScreen({
    super.key,
  });

  @override
  State<UserCartsScreen> createState() => _UserCartsScreenState();
}

class _UserCartsScreenState extends State<UserCartsScreen> {
  User? workshop;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Cart",
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
      ),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(
              horizontal: getWidthMargin(context, 2),
              vertical: getWidthMargin(context, 1)),
          child: Consumer<UserCartProvider>(
            builder: (context, value, child) {
              return value.carts.isEmpty || value.isLoading
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Amount",
                              style: titleHeader,
                            ),
                            Text(
                              value.getTotal().toString(),
                              style: titleHeader,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getWidthMargin(context, 5),
                        ),
                        // _TitleTextWidget(
                        //     title: "Bank Name",
                        //     text: workshop!.bname.toString()),
                        SizedBox(
                          width: getScreenWidth(context),
                          child: CustomButton(
                              text: "Place Order",
                              color: getPrimaryColor(context),
                              onClick: () {
                                value.placeOrder(context);
                              }),
                        ),
                        SizedBox(
                          height: getWidthMargin(context, 5),
                        ),
                        const Text(
                          "Cash on Delivery",
                          style: titleHeader,
                        ),
                      ],
                    );
            },
          )),
      body: SafeArea(
        child: Consumer<UserCartProvider>(
          builder: (context, value, child) {
            return value.isLoading
                ? LottieAnimationWidget(MyAnimations.loader)
                : value.carts.isEmpty
                    ? LottieAnimationWidget(MyAnimations.empty)
                    : ItemGridView(true, value.getItems());
          },
        ),
      ),
    );
  }
}

class _TitleTextWidget extends StatelessWidget {
  String title, text;

  Color? valueColor;

  _TitleTextWidget({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleHeader.copyWith(color: ColorResources.DARK_GREY),
          ),
          Text(
            text,
            style: titleHeader.copyWith(
                color: valueColor ?? ColorResources.DARK_GREY.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
