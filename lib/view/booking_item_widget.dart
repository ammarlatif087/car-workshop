import 'package:flutter/material.dart';
import 'package:workshop/model/booking_model.dart';
import 'package:workshop/view/work_shop_book_details_screen.dart';

import '../utils/color_resources.dart';
import '../utils/custom_style.dart';
import '../utils/utils.dart';
import 'decorated_container.dart';
import 'horizontal_chip_view.dart';

class BookingItemWidget extends StatelessWidget {
  BookingModel data;

  bool forWorkshop;
  bool viewOnly;

  BookingItemWidget(this.data,
      {super.key, this.forWorkshop = false, this.viewOnly = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        startNewScreenWithRoot(
            context,
            WorkshopBookingDetailScreen(
                serviceSchedule: data.serviceSchedule,
                bookingModel: data,
                viewOnly: viewOnly,
                forWorkshop: forWorkshop),
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
                        Text(data.serviceSchedule.modelNo,
                            style: titleHeader.copyWith(
                                color: getTitleColor(context, opacity: 1))),
                        Text(data.serviceSchedule.getDuration(),
                            style: titleRegular.copyWith(
                                color: getTitleColor(context, opacity: 0.7))),
                        Text("Day: ${data.selectedDay}",
                            style: titleRegular.copyWith(
                                color: getTitleColor(context, opacity: 0.7))),
                      ],
                    ),
                  ),
                  Chip(
                    backgroundColor: data.getStatusColor(),
                    label: Text(data.status,
                        style:
                            titleRegular.copyWith(color: ColorResources.WHITE)),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              HorizontalChipsWidget(
                list: data.serviceSchedule.services,
                backgroundColor: getPrimaryColor(context),
                textColor: Colors.white,
              )
            ],
          )),
    );
  }
}
