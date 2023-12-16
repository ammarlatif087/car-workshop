import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workshop/auth/sign_in_screen.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/package.dart';
import 'package:workshop/provider/subscription_provider.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image.dart';
import 'package:workshop/view/loader_view.dart';

import '../model/user.dart';
import '../utils/custom_style.dart';

class PackageDetailsScreen extends StatefulWidget {
  Package package;

  PackageDetailsScreen(this.package, {super.key});

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      DataSnapshot dataSnapshot = await firebaseDatabase
          .ref("Users")
          .child(widget.package.userId!)
          .get();
      Map<dynamic, dynamic>? json = dataSnapshot.value as Map?;

      if (json != null) {
        user = User.fromJson(json);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Subscription Details",
          style: titleHeader.copyWith(color: ColorResources.WHITE),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
                text: "Reject",
                color: ColorResources.RED,
                onClick: () {
                  confirmationDialog(context,
                      "Are you sure you want to reject this subscription",
                      onCancel: () {
                    popWidget(context);
                  }, onYes: () {
                    SubscriptionProvider provider =
                        getProvider<SubscriptionProvider>(context);
                    provider.updatePackage(context, widget.package, "Rejected");
                  });
                }),
            CustomButton(
                text: "Accept",
                color: ColorResources.GREEN,
                onClick: () {
                  confirmationDialog(context,
                      "Are you sure you want to reject this subscription",
                      onCancel: () {
                    popWidget(context);
                  }, onYes: () {
                    SubscriptionProvider provider =
                        getProvider<SubscriptionProvider>(context);
                    provider.updatePackage(context, widget.package, "Accepted");
                  });
                }),
          ],
        ),
      ),
      body: SafeArea(
        child: user == null
            ? LottieAnimationWidget(MyAnimations.loader)
            : SingleChildScrollView(
                physics: getBouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: getHeightMargin(context, 5),
                    ),
                    CustomImage(
                      image: user!.imageUrl.toString(),
                      height: 100,
                      width: 100,
                      isCircleImage: true,
                    ),
                    SizedBox(
                      height: getHeightMargin(context, 2),
                    ),
                    _TitleTextWidget(
                        title: "User", text: user!.name.toString()),
                    SizedBox(
                      height: getHeightMargin(context, 2),
                    ),
                    _TitleTextWidget(
                        title: "Email", text: user!.email.toString()),
                    SizedBox(
                      height: getHeightMargin(context, 2),
                    ),
                    _TitleTextWidget(
                        title: "Address", text: user!.address.toString()),
                    SizedBox(
                      height: getHeightMargin(context, 2),
                    ),
                    _TitleTextWidget(
                        title: "Package", text: widget.package.title),
                    SizedBox(
                      height: getHeightMargin(context, 2),
                    ),
                    _TitleTextWidget(
                        title: "Rate", text: widget.package.rate.toString()),
                    SizedBox(
                      height: getHeightMargin(context, 2),
                    ),
                    _TitleTextWidget(
                        title: "Duration",
                        text:
                            "${getUserFormattedDate(widget.package.startDate!)} to ${getUserFormattedDate(widget.package.endDate!)}"),
                    SizedBox(
                      height: getHeightMargin(context, 2),
                    ),
                    _TitleTextWidget(title: "Attachment", text: ""),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: CustomImage(
                          image: widget.package.attachment!,
                          height: getScreenWidth(context),
                          width: getScreenWidth(context)),
                    ),
                    SizedBox(
                      height: getHeightMargin(context, 2),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _TitleTextWidget extends StatelessWidget {
  String title, text;
  Color? valueColor;

  _TitleTextWidget({required this.title, required this.text, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: titleHeader.copyWith(color: ColorResources.DARK_GREY),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: titleHeader.copyWith(
                  color:
                      valueColor ?? ColorResources.DARK_GREY.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
