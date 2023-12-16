import 'package:flutter/material.dart';
import 'package:workshop/model/order_model.dart';
import 'package:workshop/screen/order_detail_screen.dart';

import '../utils/color_resources.dart';
import '../utils/custom_style.dart';
import '../utils/utils.dart';
import 'decorated_container.dart';

class OrderWidget extends StatelessWidget {
  OrderModel data;
  bool forWorkshop;

  OrderWidget(this.data, {this.forWorkshop = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        startNewScreenWithRoot(
            context,
            OrderDetailsScreen(
              orderModel: data,
              forWorkshop: forWorkshop,
            ),
            true);
      },
      child: DecoratedContainer(
          margin: EdgeInsets.symmetric(
              horizontal: getWidthMargin(context, 1),
              vertical: getWidthMargin(context, 1)),
          padding: EdgeInsets.symmetric(
              horizontal: getWidthMargin(context, 2),
              vertical: getWidthMargin(context, 2)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getUserFormattedDate(data.date),
                            style: titleHeader.copyWith(
                                color: getTitleColor(context, opacity: 1))),
                        Text(getUserFormattedTime(data.time),
                            style: titleRegular.copyWith(
                                color: getTitleColor(context, opacity: 0.7))),
                        Text("Items: ${data.items.length}",
                            style: titleRegular.copyWith(
                                color: getTitleColor(context, opacity: 0.7))),
                        Text("Total: ${data.getTotal()}",
                            style: titleRegular.copyWith(
                                color: getTitleColor(context, opacity: 0.7))),
                      ],
                    ),
                  ),
                  Chip(
                    backgroundColor: data.status == "Accepted"
                        ? ColorResources.GREEN
                        : data.status == "Denied"
                            ? ColorResources.RED
                            : ColorResources.YELLOW,
                    label: Text(data.status,
                        style:
                            titleRegular.copyWith(color: ColorResources.WHITE)),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
