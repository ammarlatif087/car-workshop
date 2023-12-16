import 'package:flutter/material.dart';
import 'package:workshop/model/package.dart';
import 'package:workshop/provider/subscription_provider.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image_picker.dart';

import '../base_view/custom_button.dart';
import '../utils/custom_style.dart';

class PackageSubscriptionScreen extends StatefulWidget {
  Package package;

  PackageSubscriptionScreen({super.key, required this.package});

  @override
  State<PackageSubscriptionScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackageSubscriptionScreen> {
  List<Package> packages = [];

  @override
  void initState() {
    super.initState();
  }

  String selectedImage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Subscribe Package",
          style: titleHeader.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(premiumIcon, height: 100, width: 100),
            SizedBox(
              height: getWidthMargin(context, 10),
            ),
            const Text('Bank Account Details'),
            const Text('EASY PAISA/JAZZCASH'),
            const Text('03439456789'),
            SizedBox(
              height: getWidthMargin(context, 2),
            ),
            _TitleTextWidget(
                title: "Title", text: widget.package.title.toString()),
            SizedBox(
              height: getWidthMargin(context, 2),
            ),
            _TitleTextWidget(
                title: "Price", text: widget.package.rate.toString()),
            SizedBox(
              height: getWidthMargin(context, 10),
            ),
            Text(
              "Pick Attachment",
              style: titleHeader.copyWith(color: ColorResources.DARK_GREY),
            ),
            SizedBox(
              height: getWidthMargin(context, 2),
            ),
            CustomImagePicker(
              imagePickerCallback: (path) {
                setState(() {
                  selectedImage = path;
                });
              },
              selectedImage: selectedImage,
            ),
            SizedBox(
              height: getWidthMargin(context, 5),
            ),
            CustomButton(
                text: "Subscribe",
                color: getPrimaryColor(context),
                onClick: () {
                  if (selectedImage.isEmpty) {
                    infoSnackBar(context, "Please add attachment");
                    return;
                  }
                  confirmationDialog(context,
                      "Are you sure you want to subscribe this package",
                      onCancel: () {
                    popWidget(context);
                  }, onYes: () {
                    getProvider<SubscriptionProvider>(context).subscribePackage(
                        context, widget.package, selectedImage);
                  });
                }),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'NOTE: Pay amount and attach the transaction slip to subscribe',
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TitleTextWidget extends StatelessWidget {
  String title, text;
  Color? valueColor;

  _TitleTextWidget({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleHeader.copyWith(color: ColorResources.DARK_GREY),
          ),
          Text(
            text,
            style: titleHeader.copyWith(
                color: valueColor ?? ColorResources.DARK_GREY.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
