import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/cart_model.dart';
import 'package:workshop/model/order_model.dart';
import 'package:workshop/provider/workshop_order_provider.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image.dart';
import 'package:workshop/view/decorated_container.dart';
import 'package:workshop/view/loader_view.dart';
import 'package:workshop/view/order_item_widget.dart';

import '../model/user.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderModel orderModel;
  bool forWorkshop;

  OrderDetailsScreen(
      {super.key, required this.orderModel, this.forWorkshop = false});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  User? workshop;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      DataSnapshot dataSnapshot;

      dataSnapshot = await firebaseDatabase
          .ref("Users")
          .child(widget.forWorkshop
              ? widget.orderModel.userId
              : widget.orderModel.workshopId)
          .get();

      Map<dynamic, dynamic>? json = dataSnapshot.value as Map?;
      print(json.toString());
      if (json != null) {
        workshop = User.fromJson(json);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WorkshopOrderProvider provider =
        getProvider<WorkshopOrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Order Details",
          style: titleRegular.copyWith(color: ColorResources.WHITE),
        ),
      ),
      bottomNavigationBar: workshop == null
          ? const SizedBox.shrink()
          : DecoratedContainer(
              padding: EdgeInsets.symmetric(
                  vertical: getWidthMargin(context, 5),
                  horizontal: getWidthMargin(context, 3)),
              margin: EdgeInsets.symmetric(
                  horizontal: getWidthMargin(context, 2),
                  vertical: getWidthMargin(context, 1)),
              child: Column(
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
                        "Rs: ${widget.orderModel.getTotal()}",
                        style: titleHeader,
                      ),
                    ],
                  ),
                  widget.forWorkshop && widget.orderModel.status == "Pending"
                      ? SizedBox(
                          height: getWidthMargin(context, 3),
                        )
                      : const SizedBox.shrink(),
                  widget.forWorkshop && widget.orderModel.status == "Pending"
                      ? Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                                text: "Deny",
                                color: ColorResources.RED,
                                onClick: () {
                                  confirmationDialog(context,
                                      "Are you sure you want to deny this order?",
                                      onCancel: () {
                                    popWidget(context);
                                  }, onYes: () {
                                    provider.updateOrder(
                                        context, widget.orderModel, "Denied");
                                  });
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                                text: "Accept",
                                color: ColorResources.GREEN,
                                onClick: () {
                                  confirmationDialog(context,
                                      "Are you sure you want to accept this order?",
                                      onCancel: () {
                                    popWidget(context);
                                  }, onYes: () {
                                    provider.updateOrder(
                                        context, widget.orderModel, "Accepted");
                                  });
                                }),
                          ],
                        )
                      : const SizedBox.shrink()
                ],
              )),
      body: SafeArea(
        child: workshop == null
            ? Center(
                child: LottieAnimationWidget(MyAnimations.loader),
              )
            : SingleChildScrollView(
                physics: getBouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CustomImage(
                              image: workshop!.imageUrl, height: 60, width: 60),
                          SizedBox(
                            width: getWidthMargin(context, 3),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workshop!.name,
                                style: titleRegular.copyWith(
                                    color: ColorResources.DARK_GREY),
                              ),
                              Text(
                                workshop!.address,
                                style: titleRegular.copyWith(
                                    color: ColorResources.DARK_GREY
                                        .withOpacity(0.5)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    widget.forWorkshop
                        ? const SizedBox.shrink()
                        : _TitleTextWidget(
                            title: "Workshop Name", text: workshop!.name),
                    widget.forWorkshop
                        ? const SizedBox.shrink()
                        : _TitleTextWidget(
                            title: "Workshop Address", text: workshop!.address),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _TitleTextWidget(
                        title: "Placed Date",
                        text: getUserFormattedDate(widget.orderModel.date)),
                    _TitleTextWidget(
                        title: "Placed Time",
                        text: getUserFormattedTime(widget.orderModel.time)),
                    _TitleTextWidget(
                        title: "Status",
                        text: widget.orderModel.status,
                        valueColor: widget.orderModel.getColorOfStatus()),
                    _TitleTextWidget(
                        title: "Not Of Items",
                        text: widget.orderModel.items.length.toString()),
                    _TitleTextWidget(
                      title: "Payment Proof",
                      text: '',
                    ),
                    CustomImage(
                        image: widget.orderModel.proofUrl,
                        height: 200,
                        width: 200),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Items",
                        style: titleHeaderExtra.copyWith(
                            color: getTitleColor(context, opacity: 1)),
                      ),
                    ),
                    BaseListView<CartModel>(
                      widget.orderModel.items,
                      baseListSeparatorBuilder: (context, index) {
                        return const Divider(
                          thickness: 1,
                        );
                      },
                      baseListWidgetBuilder: (data, pos) {
                        return OrderItemWidget(item: data);
                      },
                      scrollable: false,
                      shrinkable: true,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class _TitleTextWidget extends StatelessWidget {
  String title, text;
  Color? valueColor;

  _TitleTextWidget({required this.title, required this.text, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleRegular.copyWith(color: ColorResources.DARK_GREY),
          ),
          Text(
            text,
            style: titleRegular.copyWith(
                color: valueColor ?? ColorResources.DARK_GREY.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
