import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workshop/auth/sign_in_screen.dart';
import 'package:workshop/model/package.dart';
import 'package:workshop/screen/approval_screen.dart';
import 'package:workshop/screen/package_approval_screen.dart';
import 'package:workshop/screen/package_subscription_screen.dart';
import 'package:workshop/screen/packages_screen.dart';
import 'package:workshop/screen/user_dashboard_screen.dart';
import 'package:workshop/screen/workshop_dashboard_screen.dart';
import 'package:workshop/utils/utils.dart';

import '../main.dart';
import 'admin_dashboard_screen.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      User? user = auth.currentUser;
      if (user != null) {
        DataSnapshot dataSnapshot =
            await firebaseDatabase.ref("Users").child(user.uid).get();
        Map<dynamic, dynamic>? json = dataSnapshot.value as Map?;
        String status = json!['status'] ?? "Pending";
        String role = json['role'];
        if (status != "Accepted" && role != "Admin") {
          pushUntil(context, ApprovalScreen(json));
          return;
        }
        if (role == "Workshop") {
          DataSnapshot dataSnapshot = await firebaseDatabase
              .ref("Subscriptions")
              .child(getUserId())
              .get();
          Map<dynamic, dynamic>? packageJson = dataSnapshot.value as Map?;
          print(packageJson.toString());

          if (packageJson == null) {
            pushUntil(context, const PackagesScreen());
          } else if (packageJson['status'] == "Accepted") {
            pushUntil(context, const WorkShopDashboardWidget());
          } else {
            pushUntil(context, PackageApprovalScreen(packageJson));
          }
        } else if (role == "User") {
          pushUntil(context, const UserDashboardWidget());
        } else if (role == "Admin") {
          pushUntil(context, const MainWidget());
        }
      } else {
        pushUntil(context, SignInScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 3)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    "WorkShop",
                    textStyle: const TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MontserratBold',
                    ),
                    textDirection: TextDirection.ltr,
                    speed: const Duration(milliseconds: 300),
                    colors: [
                      Theme.of(context).primaryColor,
                      Colors.black87,
                      Theme.of(context).primaryColor,
                      Colors.black54,
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
