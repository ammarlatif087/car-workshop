import 'package:flutter/material.dart';
import 'package:workshop/auth/sign_in_screen.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/package.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/utils.dart';

import '../model/user.dart';
import '../utils/custom_style.dart';

class PackageApprovalScreen extends StatelessWidget {
  Map<dynamic, dynamic>? package;

  PackageApprovalScreen(this.package, {super.key});

  @override
  Widget build(BuildContext context) {
    Package package = Package.fromJson(this.package!);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(premiumIcon, width: 100, height: 100),
              SizedBox(
                height: getHeightMargin(context, 2),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: getWidthMargin(context, 10)),
                child: Text(
                  package.status == "Pending"
                      ? "Package Subscription request has pending."
                      : "Package subscription request has rejected.",
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
