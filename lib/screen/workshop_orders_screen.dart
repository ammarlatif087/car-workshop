import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/model/booking_model.dart';
import 'package:workshop/model/order_model.dart';
import 'package:workshop/model/user.dart';
import 'package:workshop/provider/user_bookings_provider.dart';
import 'package:workshop/provider/user_order_provider.dart';
import 'package:workshop/screen/add_complaint_screen.dart';
import 'package:workshop/screen/user_complaint_detail_screen.dart';
import 'package:workshop/screen/user_detail_screen.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/decorated_container.dart';
import 'package:workshop/view/horizontal_chip_view.dart';
import 'package:workshop/view/loader_view.dart';
import 'package:workshop/view/order_widget.dart';
import 'package:workshop/view/work_shop_book_details_screen.dart';

import '../model/complaint.dart';
import '../provider/workshop_order_provider.dart';

class WorkshopOrdersScreen extends StatefulWidget {
  WorkshopOrdersScreen({
    super.key,
  });

  @override
  State<WorkshopOrdersScreen> createState() => _WorkshopOrdersScreenState();
}

class _WorkshopOrdersScreenState extends State<WorkshopOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WorkshopOrderProvider userBookingsProvider =
        getProvider<WorkshopOrderProvider>(context);
    userBookingsProvider.orders.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userBookingsProvider.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Orders",
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: SafeArea(
        child: Consumer<WorkshopOrderProvider>(
          builder: (context, value, child) {
            return value.isLoading
                ? LottieAnimationWidget(MyAnimations.loader)
                : value.orders.isEmpty
                    ? LottieAnimationWidget(MyAnimations.empty)
                    : BaseListView<OrderModel>(
                        value.orders,
                        scrollable: true,
                        baseListWidgetBuilder: (data, pos) {
                          return OrderWidget(data,forWorkshop: true,);
                        },
                      );
          },
        ),
      ),
    );
  }
}
