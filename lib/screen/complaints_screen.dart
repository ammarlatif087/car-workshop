import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/provider/user_complain_provider.dart';
import 'package:workshop/screen/add_complaint_screen.dart';
import 'package:workshop/screen/user_complaint_detail_screen.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/decorated_container.dart';
import 'package:workshop/view/loader_view.dart';

import '../model/complaint.dart';

class ComplaintsScreen extends StatefulWidget {
  bool isForUser;

  ComplaintsScreen({
    super.key,
    this.isForUser = false,
  });

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  @override
  void initState() {
    super.initState();
    UserComplainProvider userComplainProvider =
        getProvider<UserComplainProvider>(context);
    userComplainProvider.complaints.clear();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userComplainProvider.getData(forUser: widget.isForUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !widget.isForUser
          ? const SizedBox.shrink()
          : FloatingActionButton(
              backgroundColor: getPrimaryColor(context),
              onPressed: () {
                startNewScreenWithRoot(context, AddComplaintScreen(), true);
              },
              child: const Icon(Icons.add, color: ColorResources.WHITE),
            ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Complaints",
          style: titleHeaderExtra.copyWith(color: ColorResources.WHITE),
        ),
      ),
      body: SafeArea(
        child: Consumer<UserComplainProvider>(
          builder: (context, value, child) {
            return value.isLoading
                ? LottieAnimationWidget(MyAnimations.loader)
                : value.complaints.isEmpty
                    ? LottieAnimationWidget(MyAnimations.empty)
                    : BaseListView<Complaint>(
                        value.complaints,
                        scrollable: true,
                        baseListWidgetBuilder: (data, pos) {
                          return InkWell(
                            onTap: () {
                              if (!widget.isForUser) {
                                startNewScreenWithRoot(context,
                                    UserComplaintDetailScreen(data), true);
                              }
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data.title,
                                              style: titleHeader.copyWith(
                                                  color: getTitleColor(context,
                                                      opacity: 1))),
                                          Text(data.message,
                                              style: titleRegular.copyWith(
                                                  color: getTitleColor(context,
                                                      opacity: 0.7))),
                                        ],
                                      ),
                                    ),
                                    Chip(
                                      backgroundColor: data.getColor(),
                                      label: Text(data.status,
                                          style: titleRegular.copyWith(
                                              color: ColorResources.WHITE)),
                                    )
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
