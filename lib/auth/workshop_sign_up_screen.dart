import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/provider/auth_provider.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/dimensions.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image_picker.dart';

import '../view/custom_text_field.dart';

// ignore: must_be_immutable
class WorkShopSignUpScreen extends StatefulWidget {
  const WorkShopSignUpScreen({super.key});

  @override
  State<WorkShopSignUpScreen> createState() => _WorkShopSignUpScreenState();
}

class _WorkShopSignUpScreenState extends State<WorkShopSignUpScreen> {
  TextEditingController emailTextController = TextEditingController();

  TextEditingController passwordTextController = TextEditingController();

  TextEditingController nameTextController = TextEditingController();

  TextEditingController addressTextController = TextEditingController();
  TextEditingController cnicCtrl = TextEditingController();
  TextEditingController acnoCtrl = TextEditingController();
  TextEditingController bankNameCtrl = TextEditingController();

  String selectedImage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 3)),
        child: SingleChildScrollView(
          physics: getBouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: getWidthMargin(context, 5)),
              Text("Register WorkShop",
                  style: titleHeaderExtra.copyWith(
                      fontSize: Dimensions.FONT_SIZE_EXTRA_EXTRA_LARGE + 10,
                      color: getPrimaryColor(context))),
              SizedBox(height: getWidthMargin(context, 5)),
              CustomImagePicker(
                  imagePickerCallback: (path) {
                    selectedImage = path;
                    setState(() {});
                  },
                  selectedImage: selectedImage),
              SizedBox(height: getWidthMargin(context, 5)),
              CustomTextField(
                textEditingController: nameTextController,
                hintText: "Enter WorkShop Name",
              ),
              SizedBox(height: getWidthMargin(context, 2)),
              CustomTextField(
                textEditingController: emailTextController,
                hintText: "Enter Email",
              ),
              SizedBox(height: getWidthMargin(context, 2)),
              CustomTextField(
                textEditingController: passwordTextController,
                hintText: "Enter Password",
              ),
              SizedBox(height: getWidthMargin(context, 2)),
              CustomTextField(
                textEditingController: addressTextController,
                hintText: "Enter Address",
              ),
              SizedBox(height: getWidthMargin(context, 2)),
              CustomTextField(
                textEditingController: cnicCtrl,
                hintText: "Enter cnic no",
              ),
              SizedBox(height: getWidthMargin(context, 2)),
              CustomTextField(
                textEditingController: bankNameCtrl,
                hintText: "Enter Bank Name",
              ),
              SizedBox(height: getWidthMargin(context, 2)),
              CustomTextField(
                textEditingController: acnoCtrl,
                hintText: "Enter Ac No",
              ),
              SizedBox(height: getWidthMargin(context, 5)),
              CustomButton(
                text: 'Sign Up',
                color: getPrimaryColor(context),
                onClick: () {
                  String email, password, name, address, cnic, acno, bName;
                  email = emailTextController.text.toString();
                  password = passwordTextController.text.toString();
                  name = nameTextController.text.toString();
                  address = addressTextController.text.toString();
                  cnic = cnicCtrl.text.toString();
                  acno = acnoCtrl.text.toString();
                  bName = bankNameCtrl.text.toString();

                  if (selectedImage.isEmpty) {
                    infoSnackBar(context, "Select Workshop Image");
                    return;
                  }
                  if (name.isEmpty) {
                    infoSnackBar(context, "Enter Workshop Name");
                    return;
                  }
                  if (email.isEmpty) {
                    infoSnackBar(context, "Enter Email");
                    return;
                  }
                  if (password.isEmpty) {
                    infoSnackBar(context, "Enter Password");
                    return;
                  }
                  if (address.isEmpty) {
                    infoSnackBar(context, "Enter Address");
                    return;
                  }
                  if (cnic.isEmpty) {
                    infoSnackBar(context, "Enter cnic");
                    return;
                  }
                  if (bName.isEmpty) {
                    infoSnackBar(context, "Enter Bank Name");
                    return;
                  }
                  if (acno.isEmpty) {
                    infoSnackBar(context, "Enter Ac no");
                    return;
                  }
                  Provider.of<AuthProvider>(context, listen: false)
                      .signUpWorkShop(
                    context,
                    email: email,
                    password: password,
                    file: File(selectedImage),
                    address: address,
                    name: name,
                    cnic: cnic,
                    bName: bName,
                    acno: acno,
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
