import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/model/user.dart';
import 'package:workshop/provider/auth_provider.dart';
import 'package:workshop/provider/home_items_provider.dart';
import 'package:workshop/provider/home_services_provider.dart';
import 'package:workshop/provider/workshops_provider.dart';
import 'package:workshop/screen/user_detail_screen.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/dimensions.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/decorated_container.dart';
import 'package:workshop/view/header_title_widget.dart';
import 'package:workshop/view/item_grid_view.dart';
import 'package:workshop/view/loader_view.dart';
import 'package:workshop/view/workshops_user_list.dart';

import '../auth/sign_in_screen.dart';
import '../main.dart';
import '../model/item_model.dart';
import '../model/service_schedule_model.dart';
import '../view/user_workshop_service_item_widget.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({
    super.key,
  });

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  void initState() {
    super.initState();

    getProvider<HomeItemsProvider>(context).items.clear();
    getProvider<HomeServicesProvider>(context).services.clear();
    getProvider<WorkshopsProvider>(context).workshops.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProvider<WorkshopsProvider>(context).getItems();
      getProvider<HomeServicesProvider>(context).getData();
      getProvider<HomeItemsProvider>(context).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Home",
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
        actions: [
          InkWell(
            onTap: () {
              auth.signOut();
              pushUntil(context, SignInScreen());
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: ColorResources.WHITE,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: getBouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderTitleTextWidget(title: "Workshops"),
              const SizedBox(height: 5),
              Consumer<WorkshopsProvider>(
                builder: (context, value, child) {
                  return value.isLoading
                      ? LottieAnimationWidget(MyAnimations.loader)
                      : value.workshops.isEmpty
                          ? LottieAnimationWidget(MyAnimations.loader)
                          : WorkshopUserListView(false, value.workshops);
                },
              ),
              const SizedBox(height: 5),
              HeaderTitleTextWidget(title: "Items"),
              const SizedBox(height: 5),
              Consumer<HomeItemsProvider>(
                builder: (context, value, child) {
                  return value.isLoading
                      ? LottieAnimationWidget(MyAnimations.loader)
                      : value.items.isEmpty
                          ? LottieAnimationWidget(MyAnimations.loader)
                          : ItemGridView(false, value.items);
                },
              ),
              const SizedBox(height: 5),
              HeaderTitleTextWidget(title: "Services"),
              const SizedBox(height: 5),
              Consumer<HomeServicesProvider>(
                builder: (context, value, child) {
                  return value.isLoading
                      ? LottieAnimationWidget(MyAnimations.loader)
                      : value.services.isEmpty
                          ? LottieAnimationWidget(MyAnimations.loader)
                          : BaseListView<ServiceSchedule>(
                              value.services,
                              scrollable: false,
                              shrinkable: true,
                              baseListWidgetBuilder: (data, pos) {
                                return UserWorkshopServiceItemWidget(
                                    data: data);
                              },
                            );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
