import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/model/booking_model.dart';
import 'package:workshop/model/order_model.dart';
import 'package:workshop/model/user.dart';
import 'package:workshop/provider/user_bookings_provider.dart';
import 'package:workshop/provider/user_order_provider.dart';
import 'package:workshop/provider/workshop_bookings_provider.dart';
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
import '../view/booking_item_widget.dart';

class WorkshopBookingsScreen extends StatefulWidget {
  const WorkshopBookingsScreen({
    super.key,
  });

  @override
  State<WorkshopBookingsScreen> createState() => _WorkshopBookingsScreenState();
}

class _WorkshopBookingsScreenState extends State<WorkshopBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WorkshopBookingsProvider userBookingsProvider =
        getProvider<WorkshopBookingsProvider>(context);
    userBookingsProvider.bookings.clear();
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
          "Bookings",
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: SafeArea(
        child: Consumer<WorkshopBookingsProvider>(
          builder: (context, value, child) {
            return value.isLoading
                ? LottieAnimationWidget(MyAnimations.loader)
                : value.bookings.isEmpty
                    ? LottieAnimationWidget(MyAnimations.empty)
                    : BaseListView<BookingModel>(
                        value.bookings,
                        scrollable: true,
                        baseListWidgetBuilder: (data, pos) {
                          return BookingItemWidget(data,forWorkshop: true,viewOnly: false,);
                        },
                      );
          },
        ),
      ),
    );
  }
}
