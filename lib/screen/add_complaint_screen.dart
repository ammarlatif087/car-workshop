import 'package:flutter/material.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/model/complaint.dart';
import 'package:workshop/provider/user_complain_provider.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/utils.dart';

import '../view/custom_text_field.dart';

// ignore: must_be_immutable
class AddComplaintScreen extends StatelessWidget {
  AddComplaintScreen({super.key});

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController messageEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Add Complaint",
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 3)),
        child: SingleChildScrollView(
          physics: getBouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: getWidthMargin(context, 5)),
              CustomTextField(
                textEditingController: titleEditingController,
                hintText: "Enter Title",
              ),
              SizedBox(height: getWidthMargin(context, 2)),
              CustomTextField(
                textEditingController: messageEditingController,
                hintText: "Enter Message",
              ),
              SizedBox(height: getWidthMargin(context, 5)),
              CustomButton(
                text: 'Add Complaint',
                color: getPrimaryColor(context),
                onClick: () {
                  String title = titleEditingController.text.toString();
                  String message = messageEditingController.text.toString();

                  if (title.isEmpty) {
                    infoSnackBar(context, "Please enter title");
                    return;
                  }
                  if (message.isEmpty) {
                    infoSnackBar(context, "Please enter message");

                    return;
                  }

                  Complaint complaint = Complaint();
                  complaint.message = message;
                  complaint.title = title;
                  complaint.userId = getUserId();
                  complaint.status = "Pending";
                  getProvider<UserComplainProvider>(context)
                      .addComplain(context, complaint);
                  popWidget(context);
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
