import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workshop/auth/sign_in_screen.dart';
import 'package:workshop/view/custom_text_field.dart';

import '../base_view/custom_button.dart';
import '../utils/color_resources.dart';
import '../utils/custom_style.dart';
import '../utils/utils.dart';

class ForgetPasswords extends StatefulWidget {
  const ForgetPasswords({super.key});

  @override
  State<ForgetPasswords> createState() => _ForgetPasswordsState();
}

class _ForgetPasswordsState extends State<ForgetPasswords> {
  TextEditingController emailCtrl = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Rest Passwords",
            style: titleRegular.copyWith(color: ColorResources.WHITE),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your Email',
                style: titleHeader,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                textEditingController: emailCtrl,
                hintText: 'Enter Your Email',
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: CustomButton(
                  text: 'Reset',
                  color: getPrimaryColor(context),
                  onClick: () {
                    String email;
                    email = emailCtrl.text.toString();

                    if (email.isEmpty) {
                      infoSnackBar(context, "Enter Email");
                      return;
                    }
                    auth.sendPasswordResetEmail(email: email).then((value) {
                      infoSnackBar(
                        context,
                        'Passords reset instruction sent to your email, please check you email',
                      );
                      pushUntil(context, const SignInScreen());
                    }).onError((error, stackTrace) {
                      infoSnackBar(context, 'Please try again $error');
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
