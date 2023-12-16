import 'package:flutter/material.dart';
import 'package:workshop/auth/sign_in_screen.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/main.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/utils.dart';

import '../model/user.dart';
import '../utils/custom_style.dart';

class ApprovalScreen extends StatelessWidget {
  Map<dynamic, dynamic>? user;

  ApprovalScreen(this.user);

  @override
  Widget build(BuildContext context) {
    User user = User.fromJson(this.user!);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(approvalImage),
              SizedBox(
                height: getHeightMargin(context, 2),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: getWidthMargin(context, 10)),
                child: Text(
                  user.status == "Pending"
                      ? "Apki Registration request abi pending hai. Please wait kren shukrya."
                      : "Apki registration request Reject kar di gai hai. Ap login nahi kr sakty shukrya.",
                  textAlign: TextAlign.center,
                  style: titleHeader.copyWith(color: ColorResources.DARK_GREY),
                ),
              ),
              SizedBox(
                height: getHeightMargin(context, 2),
              ),
              CustomButton(
                  text: "Logout",
                  color: getPrimaryColor(context),
                  onClick: () {
                    auth.signOut();
                    pushUntil(context, SignInScreen());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
