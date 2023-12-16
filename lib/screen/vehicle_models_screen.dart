import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/model/user.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/provider/vehicles_provider.dart';
import 'package:workshop/provider/workshop_items_provider.dart';
import 'package:workshop/screen/add_item_screen.dart';
import 'package:workshop/screen/add_vehicle_model_screen.dart';
import 'package:workshop/screen/user_detail_screen.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/dimensions.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image.dart';
import 'package:workshop/view/decorated_container.dart';
import 'package:workshop/view/horizontal_chip_view.dart';
import 'package:workshop/view/item_grid_view.dart';

import '../model/item_model.dart';
import '../view/loader_view.dart';

class VehicleModelsScreen extends StatefulWidget {
  const VehicleModelsScreen({
    super.key,
  });

  @override
  State<VehicleModelsScreen> createState() => _VehicleModelsScreenState();
}

class _VehicleModelsScreenState extends State<VehicleModelsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<VehiclesProvider>(context, listen: false).getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          startNewScreenWithRoot(context, AddVehicleModelScreen(), true);
        },
        backgroundColor: getPrimaryColor(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Service Schedules",
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: SafeArea(
        child: Consumer<VehiclesProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.items.isEmpty
                    ? LottieAnimationWidget(MyAnimations.empty)
                    : BaseListView<ServiceSchedule>(
                        provider.items,
                        scrollable: true,
                        baseListWidgetBuilder: (data, pos) {
                          return InkWell(
                            onTap: () {},
                            child: DecoratedContainer(
                                margin: EdgeInsets.symmetric(
                                    horizontal: getWidthMargin(context, 2),
                                    vertical: getWidthMargin(context, 1)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: getWidthMargin(context, 2),
                                    vertical: getWidthMargin(context, 2)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data.modelNo,
                                              style: titleHeader.copyWith(
                                                  color: getTitleColor(context,
                                                      opacity: 1))),
                                          Text(
                                              "${getUserFormattedTime(data.startTime)} To ${getUserFormattedTime(data.endTime)}",
                                              style: titleRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL,
                                                  color: getTitleColor(context,
                                                      opacity: 0.7))),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          HorizontalChipsWidget(
                                              list: data.servicesV2.map((e) => e.name).toList()),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          HorizontalChipsWidget(
                                              list: data.days),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                        child: const Icon(
                                          Icons.edit,
                                          color: ColorResources.RED,
                                        ),
                                        onTap: () {
                                          startNewScreenWithRoot(
                                              context,
                                              AddVehicleModelScreen(item: data),
                                              true);
                                        }),
                                  ],
                                )),
                          );
                        },
                      );
          },
        ),
      ),
    );
  }
}
