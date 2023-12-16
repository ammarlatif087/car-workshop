import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/provider/workshop_details_provider.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/item_grid_view.dart';
import 'package:workshop/view/loader_view.dart';
import 'package:workshop/view/user_workshop_service_item_widget.dart';

import '../model/service_schedule_model.dart';

class WorkshopDetailsScreen extends StatefulWidget {
  WorkshopDetailsScreen({
    super.key,
  });

  @override
  State<WorkshopDetailsScreen> createState() => _WorkshopDetailsScreenState();
}

class _WorkshopDetailsScreenState extends State<WorkshopDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      WorkshopDetailsProvider provider =
          getProvider<WorkshopDetailsProvider>(context);
      provider.getItems();
      provider.getServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Workshops Details",
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: getBouncingScrollPhysics(),
          child: Consumer<WorkshopDetailsProvider>(
            builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Items",
                      style: titleHeaderExtra.copyWith(
                          color: getTitleColor(context, opacity: 1)),
                    ),
                  ),
                  value.isLoading
                      ? LottieAnimationWidget(MyAnimations.loader)
                      : value.items.isEmpty
                          ? LottieAnimationWidget(MyAnimations.loader)
                          : ItemGridView(false, value.items),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Services",
                      style: titleHeaderExtra.copyWith(
                          color: getTitleColor(context, opacity: 1)),
                    ),
                  ),
                  value.isServicesLoading
                      ? LottieAnimationWidget(MyAnimations.loader)
                      : value.services.isEmpty
                          ? LottieAnimationWidget(MyAnimations.loader)
                          : BaseListView<ServiceSchedule>(
                              value.services,
                              scrollable: false,
                              shrinkable: true,
                              baseListWidgetBuilder: (data, pos) {
                                return UserWorkshopServiceItemWidget(
                                    data: data);
                              },
                            ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
