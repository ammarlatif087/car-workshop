import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/user.dart';
import 'package:workshop/provider/user_complain_provider.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image.dart';
import 'package:workshop/view/decorated_container.dart';
import 'package:workshop/view/loader_view.dart';

import '../model/complaint.dart';

// ignore: must_be_immutable
class UserComplaintDetailScreen extends StatefulWidget {
  Complaint complaint;

  UserComplaintDetailScreen(this.complaint, {super.key});

  @override
  State<UserComplaintDetailScreen> createState() =>
      _UserComplaintDetailScreenState();
}

class _UserComplaintDetailScreenState extends State<UserComplaintDetailScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      DataSnapshot dataSnapshot = await firebaseDatabase
          .ref("Users")
          .child(widget.complaint.userId)
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
        elevation: 0,
        title: Text(
          "Complaint Details",
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: SafeArea(
          child: user == null
              ? LottieAnimationWidget(MyAnimations.loader)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: getWidthMargin(context, 5)),
                    Center(
                      child: CustomImage(
                        height: 100,
                        width: 100,
                        image: user!.imageUrl,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Center(
                      child: Text(user!.name,
                          style: titleHeaderExtra.copyWith(
                              color: getTitleColor(context, opacity: 1))),
                    ),
                    Center(
                      child: Text(user!.email,
                          style: titleRegular.copyWith(
                              color: getTitleColor(context, opacity: 1))),
                    ),
                    Center(
                      child: Text(user!.address,
                          style: titleRegular.copyWith(
                              color: getTitleColor(context, opacity: 1))),
                    ),
                    const SizedBox(height: 2),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Title:  ${widget.complaint.title}",
                          style: titleRegular.copyWith(
                              color: getTitleColor(context, opacity: 0.7))),
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Message:  ${widget.complaint.message}",
                          style: titleRegular.copyWith(
                              color: getTitleColor(context, opacity: 0.7))),
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Status:  ${widget.complaint.status}",
                          style: titleRegular.copyWith(
                              color: widget.complaint.getColor())),
                    ),
                    SizedBox(height: getHeightMargin(context, 5)),
                    widget.complaint.status == "Pending"
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
                                            "Are you sure you want to resolve this issue",
                                            onCancel: () {
                                          popWidget(context);
                                        }, onYes: () {
                                          popWidget(context);
                                          getProvider<UserComplainProvider>(
                                                  context)
                                              .update(context, widget.complaint,
                                                  "Rejected");
                                        });
                                      }),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: CustomButton(
                                      text: "Resolved",
                                      color: ColorResources.GREEN,
                                      onClick: () {
                                        confirmationDialog(context,
                                            "Are you sure you want to resolve this issue",
                                            onCancel: () {
                                          popWidget(context);
                                        }, onYes: () {
                                          popWidget(context);
                                          getProvider<UserComplainProvider>(
                                                  context)
                                              .update(context, widget.complaint,
                                                  "Resolved");
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
