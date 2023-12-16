import 'package:flutter/material.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/model/package.dart';
import 'package:workshop/screen/package_subscription_screen.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/decorated_container.dart';

import '../base_view/custom_button.dart';
import '../utils/custom_style.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  List<Package> packages = [];

  @override
  void initState() {
    super.initState();
    packages.add(Package(title: "Weekly Package", rate: 1000, days: 7, id: 1));
    packages
        .add(Package(title: "Monthly Package", rate: 5000, days: 30, id: 2));
    packages
        .add(Package(title: "Yearly Package", rate: 10000, days: 365, id: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Subscribe Package To Continue",
          style: titleHeader.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: BaseListView<Package>(
        packages,
        scrollable: true,
        baseListWidgetBuilder: (data, pos) {
          return DecoratedContainer(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(premiumIcon, height: 60, width: 60),
                    SizedBox(
                      width: getWidthMargin(context, 5),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: titleHeader.copyWith(
                              color: getPrimaryColor(context)),
                        ),
                        Text(
                          "Rs: ${data.rate}",
                          style: titleRegular.copyWith(
                              color: ColorResources.DARK_GREY),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: getWidthMargin(context, 5),
                ),
                Center(
                  child: CustomButton(
                      text: 'Subscribe',
                      color: getPrimaryColor(context),
                      onClick: () {
                        startNewScreenWithRoot(context,
                            PackageSubscriptionScreen(package: data), true);
                      }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
