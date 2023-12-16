import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/auth/sign_in_screen.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/main.dart';
import 'package:workshop/provider/profile_provider.dart';
import 'package:workshop/screen/profile_update_screen.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image.dart';
import 'package:workshop/view/loader_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    ProfileProvider provider = getProvider<ProfileProvider>(context);
    provider.user = null;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      provider.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Profile",
          style: titleHeader.copyWith(color: Colors.white),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          return SafeArea(
            child: value.user == null
                ? Center(child: LottieAnimationWidget(MyAnimations.loader))
                : SingleChildScrollView(
                    physics: getBouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: getWidthMargin(context, 10),
                        ),
                        Center(
                          child: CustomImage(
                              image: value.user!.imageUrl,
                              height: getScreenWidth(context) / 3,
                              width: getScreenWidth(context) / 3),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              value.user!.name,
                              style: titleHeader.copyWith(
                                  color: ColorResources.DARK_GREY),
                            ),
                            InkWell(
                              onTap: () {
                                startNewScreenWithRoot(
                                    context, ProfileUpdateScreen(), true);
                              },
                              child: const Icon(
                                Icons.edit,
                                color: ColorResources.RED,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          value.user!.email,
                          style: titleRegular.copyWith(
                              color: ColorResources.DARK_GREY.withOpacity(0.5)),
                        ),
                        Text(
                          value.user!.address,
                          style: titleRegular.copyWith(
                              color: ColorResources.DARK_GREY.withOpacity(0.5)),
                        ),
                        SizedBox(
                          height: getWidthMargin(context, 5),
                        ),
                        CustomButton(
                            text: "Logout",
                            color: getPrimaryColor(context),
                            onClick: () {
                              auth.signOut();
                              pushUntil(context, SignInScreen());
                            })
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
