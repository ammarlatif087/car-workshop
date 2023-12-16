import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/model/package.dart';
import 'package:workshop/provider/subscription_provider.dart';
import 'package:workshop/screen/package_details_screen.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/decorated_container.dart';
import 'package:workshop/view/loader_view.dart';

import '../utils/custom_style.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<SubscriptionsScreen> {
  @override
  void initState() {
    super.initState();

    SubscriptionProvider subscriptionProvider =
        getProvider<SubscriptionProvider>(context);
    subscriptionProvider.subscription.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subscriptionProvider.getPendingSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Pending Subscriptions",
          style: titleHeader.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, value, child) {
          return value.isLoading
              ? LottieAnimationWidget(MyAnimations.loader)
              : value.subscription.isEmpty
                  ? LottieAnimationWidget(MyAnimations.empty)
                  : BaseListView<Package>(
                      value.subscription,
                      scrollable: true,
                      baseListWidgetBuilder: (data, pos) {
                        return DecoratedContainer(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: InkWell(
                            onTap: () {
                              startNewScreenWithRoot(
                                  context, PackageDetailsScreen(data), true);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(premiumIcon,
                                        height: 60, width: 60),
                                    SizedBox(
                                      width: getWidthMargin(context, 5),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.title,
                                          style: titleHeader.copyWith(
                                              color: getPrimaryColor(context)),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "${getUserFormattedDate(data.startDate!)} to ${getUserFormattedDate(data.endDate!)}",
                                            maxLines: 2,
                                            style: titleRegular.copyWith(
                                                overflow: TextOverflow.ellipsis,
                                                color:
                                                    ColorResources.DARK_GREY),
                                          ),
                                        ),
                                        Text(
                                          "Rs: ${data.rate}",
                                          style: titleRegular.copyWith(
                                              color: ColorResources.DARK_GREY),
                                        ),
                                        Text(
                                          "Status: ${data.status}",
                                          style: titleRegular.copyWith(
                                              color: ColorResources.DARK_GREY),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
    );
  }
}
