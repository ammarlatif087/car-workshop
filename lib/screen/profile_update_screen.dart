import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/model/user.dart';
import 'package:workshop/provider/auth_provider.dart';
import 'package:workshop/provider/profile_provider.dart';
import 'package:workshop/screen/user_dashboard_screen.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/dimensions.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image_picker.dart';
import 'package:workshop/view/decorated_container.dart';

import '../view/custom_text_field.dart';

// ignore: must_be_immutable
class ProfileUpdateScreen extends StatefulWidget {
  ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  TextEditingController emailTextController = TextEditingController();

  // TextEditingController passwordTextController = TextEditingController();

  TextEditingController nameTextController = TextEditingController();

  TextEditingController addressTextController = TextEditingController();

  String imagePath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Update Profile",
          style: titleHeader.copyWith(color: Colors.white),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          nameTextController.text = value.user!.name;
          emailTextController.text = value.user!.email;
          addressTextController.text = value.user!.address;
          return SafeArea(
              child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getWidthMargin(context, 3)),
            child: SingleChildScrollView(
              physics: getBouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: getWidthMargin(context, 5)),

                  CustomImagePicker(
                      imagePickerCallback: (path) {
                        imagePath = path;
                        setState(() {});
                      },
                      networkImage: value.user!.imageUrl,
                      selectedImage: imagePath),
                  SizedBox(height: getWidthMargin(context, 5)),

                  CustomTextField(
                    viewOnly: true,
                    textEditingController: emailTextController,
                    hintText: "Enter Email",
                  ),

                  SizedBox(height: getWidthMargin(context, 2)),
                  CustomTextField(
                    textEditingController: nameTextController,
                    hintText: "Enter Name",
                  ),
                  SizedBox(height: getWidthMargin(context, 2)),
                  // CustomTextField(
                  //   textEditingController: passwordTextController,
                  //   hintText: "Enter Password",
                  // ),
                  // SizedBox(height: getWidthMargin(context, 2)),
                  CustomTextField(
                    textEditingController: addressTextController,
                    hintText: "Enter Address",
                  ),
                  SizedBox(height: getWidthMargin(context, 5)),
                  CustomButton(
                    text: 'Update',
                    color: getPrimaryColor(context),
                    onClick: () {
                      String email, password, name, address;
                      email = emailTextController.text.toString();
                      // password = passwordTextController.text.toString();
                      name = nameTextController.text.toString();
                      address = addressTextController.text.toString();

                      // if (imagePath.isEmpty) {
                      //   infoSnackBar(context, "Please select image");
                      //
                      //   return;
                      // }
                      if (name.isEmpty) {
                        infoSnackBar(context, "Enter Name");
                        return;
                      }
                      if (address.isEmpty) {
                        infoSnackBar(context, "Enter Address");
                        return;
                      }

                      value.updateUser(context, name, address,
                          imagePath.isEmpty ? null : File(imagePath));

                      // if (email.isEmpty) {
                      //   infoSnackBar(context, "Enter Email");
                      //   return;
                      // }
                      // if (password.isEmpty) {
                      //   infoSnackBar(context, "Enter Password");
                      //   return;
                      // }
                    },
                  )
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}
