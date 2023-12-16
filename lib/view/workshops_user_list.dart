import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/provider/workshop_details_provider.dart';
import 'package:workshop/screen/workshop_details_screen.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image.dart';

import '../model/item_model.dart';
import '../model/user.dart';
import '../utils/color_resources.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import 'item_widget.dart';

class WorkshopUserListView extends StatelessWidget {
  bool isScrollable;
  List<User> workshops;

  WorkshopUserListView(this.isScrollable, this.workshops);

  @override
  Widget build(BuildContext context) {
    return BaseListView<User>(
      workshops,
      baseListWidgetBuilder: (data, pos) {
        return InkWell(
          onTap: () {
            getProvider<WorkshopDetailsProvider>(context).setWokShop(data);
            startNewScreenWithRoot(context, WorkshopDetailsScreen(), true);
          },
          child: Card(
            margin: EdgeInsets.symmetric(
                horizontal: getWidthMargin(context, 2),
                vertical: getWidthMargin(context, 1)),
            elevation: 10,
            shape: getCardShape(20),
            child: SizedBox(
              // height: height,
              // width: width,
              // padding: const EdgeInsets.symmetric(
              //     vertical: Dimensions.PADDING_SIZE_SMALL),
              child: Stack(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomImage(
                            image: data.imageUrl,
                            height: getScreenHeight(context) / 4,
                            width: getScreenWidth(context)),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_LARGE),
                          child: Text(
                            data.name,
                            style: titleRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                                color: getTitleColor(context, opacity: 1)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: (){

                            MapsLauncher.launchQuery(data.address);


                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            child: Text(
                              data.address,
                              style: titleRegular.copyWith(
                                  color: getTitleColor(context, opacity: 0.7)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [],
                          ),
                        )
                      ]),
                ],
              ),
            ),
          ),
        );
      },
      scrollable: isScrollable,
      shrinkable: !isScrollable,
    );
  }
}
