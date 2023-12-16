import 'package:flutter/material.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/model/user.dart';
import 'package:workshop/provider/users_provider.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image.dart';

// ignore: must_be_immutable
class UserDetailScreen extends StatelessWidget {
  User user;
  String title;

  UserDetailScreen(this.user, {super.key, this.title = "User Details"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          title,
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: getWidthMargin(context, 5)),
          Center(
              child:
                  CustomImage(image: user.imageUrl, height: 150, width: 150)),
          SizedBox(height: getWidthMargin(context, 5)),
          Text(user.name,
              style: titleHeaderExtra.copyWith(
                  color: getTitleColor(context, opacity: 1))),
          // const SizedBox(height: 2),
          // Text(user.gender,
          //     style: titleRegular.copyWith(
          //         color: getTitleColor(context, opacity: 0.7))),
          const SizedBox(height: 2),
          Text(user.email,
              style: titleRegular.copyWith(
                  color: getTitleColor(context, opacity: 0.7))),
          const SizedBox(height: 2),
          Text(user.address,
              style: titleRegular.copyWith(
                  color: getTitleColor(context, opacity: 0.7))),
          const SizedBox(height: 2),
          Text(user.status.toString(),
              style: titleRegular.copyWith(
                  color: getTitleColor(context, opacity: 0.7))),
          SizedBox(height: getHeightMargin(context, 5)),
          user.status == "Pending"
              ? Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: getWidthMargin(context, 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomButton(
                            text: "Reject",
                            color: ColorResources.RED,
                            onClick: () {
                              confirmationDialog(context,
                                  "Are you sure you want to rejected this user registration",
                                  onCancel: () {
                                popWidget(context);
                              }, onYes: () {
                                popWidget(context);

                                getProvider<UsersProvider>(context)
                                    .updateUserStatus(
                                        context, user, "Rejected");
                              });
                            }),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: CustomButton(
                            text: "Accept",
                            color: getPrimaryColor(context),
                            onClick: () {
                              confirmationDialog(context,
                                  "Are you sure you want to accept this user registration",
                                  onCancel: () {
                                popWidget(context);
                              }, onYes: () {
                                popWidget(context);

                                getProvider<UsersProvider>(context)
                                    .updateUserStatus(
                                        context, user, "Accepted");
                              });
                            }),
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink()
        ],
      )),
    );
  }
}
