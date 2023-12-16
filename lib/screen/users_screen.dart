import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/model/user.dart';
import 'package:workshop/provider/users_provider.dart';
import 'package:workshop/screen/user_detail_screen.dart';
import 'package:workshop/utils/MyImages.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image.dart';
import 'package:workshop/view/decorated_container.dart';
import 'package:workshop/view/loader_view.dart';

class UsersScreen extends StatefulWidget {
  String title;
  String detailsTitle;
  bool isRemoveOptionShow;
  String role;

  UsersScreen(
      {super.key,
      this.isRemoveOptionShow = false,
      required this.title,
      required this.role,
      this.detailsTitle = "User Details"});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    UsersProvider usersProvider = getProvider<UsersProvider>(context);
    usersProvider.users.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      usersProvider.getUsers(widget.role);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.title,
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: SafeArea(
        child: Consumer<UsersProvider>(
          builder: (context, value, child) {
            return value.isLoading
                ? LottieAnimationWidget(MyAnimations.loader)
                : value.users.isEmpty
                    ? LottieAnimationWidget(MyAnimations.empty)
                    : BaseListView<User>(
                        value.users,
                        scrollable: true,
                        baseListWidgetBuilder: (data, pos) {
                          return InkWell(
                            onTap: () {
                              startNewScreenWithRoot(
                                  context,
                                  UserDetailScreen(data,
                                      title: widget.detailsTitle),
                                  true);
                            },
                            child: DecoratedContainer(
                                margin: EdgeInsets.symmetric(
                                    horizontal: getWidthMargin(context, 1),
                                    vertical: getWidthMargin(context, 1)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: getWidthMargin(context, 2),
                                    vertical: getWidthMargin(context, 2)),
                                child: Row(
                                  children: [
                                    CustomImage(
                                        image: data.imageUrl,
                                        height: 60,
                                        width: 60),
                                    SizedBox(width: getWidthMargin(context, 1)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data.name,
                                              style: titleHeader.copyWith(
                                                  color: getTitleColor(context,
                                                      opacity: 1))),
                                          Text(data.email,
                                              style: titleRegular.copyWith(
                                                  color: ColorResources
                                                      .DARK_GREY
                                                      .withOpacity(0.5))),
                                          Text(data.address,
                                              style: titleRegular.copyWith(
                                                  color: ColorResources
                                                      .DARK_GREY
                                                      .withOpacity(0.5))),
                                          Text(data.status.toString(),
                                              style: titleRegular.copyWith(
                                                  color: ColorResources
                                                      .DARK_GREY
                                                      .withOpacity(0.5))),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        },
                      );
          },
        ),
      ),
    );
  }
}
