import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/auth/user_sign_up_screen.dart';
import 'package:workshop/auth/workshop_sign_up_screen.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/main.dart';
import 'package:workshop/provider/auth_provider.dart';
import 'package:workshop/screen/forget_passwords.dart';
import 'package:workshop/screen/workshop_dashboard_screen.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/dimensions.dart';
import 'package:workshop/utils/utils.dart';

import '../view/custom_text_field.dart';

// ignore: must_be_immutable
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailTextController = TextEditingController();

  TextEditingController passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      pushUntil(context, const WorkShopDashboardWidget());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 3)),
        child: Center(
          child: SingleChildScrollView(
            physics: getBouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(avatarImage,
                    height: getScreenWidth(context) / 2,
                    width: getScreenWidth(context) / 2),
                SizedBox(height: getWidthMargin(context, 5)),
                Text("Login",
                    style: titleHeaderExtra.copyWith(
                        fontSize: Dimensions.FONT_SIZE_EXTRA_EXTRA_LARGE + 10,
                        color: getPrimaryColor(context))),
                SizedBox(height: getWidthMargin(context, 5)),
                CustomTextField(
                  textEditingController: emailTextController,
                  textInputType: TextInputType.emailAddress,
                  hintText: "Enter Email",
                ),
                SizedBox(height: getWidthMargin(context, 2)),
                CustomTextField(
                  textEditingController: passwordTextController,
                  hintText: "Enter Password",
                ),
                SizedBox(height: getWidthMargin(context, 5)),
                CustomButton(
                  text: 'Login',
                  color: getPrimaryColor(context),
                  onClick: () {
                    String email, password, name, address;
                    email = emailTextController.text.toString();
                    password = passwordTextController.text.toString();

                    if (email.isEmpty) {
                      infoSnackBar(context, "Enter Email");
                      return;
                    }
                    if (password.isEmpty) {
                      infoSnackBar(context, "Enter Password");
                      return;
                    }

                    Provider.of<AuthProvider>(context, listen: false).signIn(
                      context,
                      email: email,
                      password: password,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      startNewScreenWithRoot(
                          context, const ForgetPasswords(), true);
                    },
                    child: Text(
                      'Forget Passwords?',
                      style: titleRegular.copyWith(
                          color: ColorResources.DARK_GREY),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: getWidthMargin(context, 5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Text(
                          "Register User",
                          style: titleHeader.copyWith(
                              color: ColorResources.DARK_GREY.withOpacity(0.5)),
                        ),
                        onTap: () {
                          // infoSnackBar(context, "This feature on later");
                          startNewScreenWithRoot(
                              context, UserSignUpScreen(), true);
                        },
                      ),
                      InkWell(
                        child: Text(
                          "Register Workshop",
                          style: titleHeader.copyWith(
                              color: ColorResources.DARK_GREY.withOpacity(0.5)),
                        ),
                        onTap: () {
                          startNewScreenWithRoot(
                              context, const WorkShopSignUpScreen(), true);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
