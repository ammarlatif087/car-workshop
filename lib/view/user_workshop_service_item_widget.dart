import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/view/work_shop_book_details_screen.dart';

import '../utils/color_resources.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/utils.dart';
import 'decorated_container.dart';

class UserWorkshopServiceItemWidget extends StatelessWidget {
  ServiceSchedule data;

  UserWorkshopServiceItemWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.modelNo,
                      style: titleHeader.copyWith(
                          color: getTitleColor(context, opacity: 1))),
                  Text(
                      "${getUserFormattedTime(data.startTime)} To ${getUserFormattedTime(data.endTime)}",
                      style: titleRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                          color: getTitleColor(context, opacity: 0.7))),
                  const SizedBox(
                    height: 5,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: getBouncingScrollPhysics(),
                    child: Row(
                      children: data.servicesV2.map((e) {
                        return Container(
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: ColorResources.DARK_GREY.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: Text(
                            e.name.toString(),
                            style: titleRegular.copyWith(
                                color: ColorResources.WHITE.withOpacity(0.8),
                                fontSize: Dimensions.FONT_SIZE_SMALL),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: getBouncingScrollPhysics(),
                    child: Row(
                      children: data.days.map((e) {
                        return Container(
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            color: ColorResources.DARK_GREY.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: Text(
                            e.toString(),
                            style: titleRegular.copyWith(
                                color: ColorResources.WHITE.withOpacity(0.8),
                                fontSize: Dimensions.FONT_SIZE_SMALL),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        startNewScreenWithRoot(
                            context,
                            WorkshopBookingDetailScreen(serviceSchedule: data),
                            true);
                      },
                      child: Chip(
                        label: Text("Book Service",
                            style: titleRegular.copyWith(
                                color: ColorResources.WHITE)),
                        backgroundColor: getPrimaryColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
