import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/auth/sign_in_screen.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/main.dart';
import 'package:workshop/provider/workshop_items_provider.dart';
import 'package:workshop/screen/add_item_screen.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image.dart';
import 'package:workshop/view/decorated_container.dart';
import 'package:workshop/view/loader_view.dart';

import '../model/item_model.dart';

class WorkShopHomeScreen extends StatefulWidget {
  const WorkShopHomeScreen({
    super.key,
  });

  @override
  State<WorkShopHomeScreen> createState() => _WorkShopHomeScreenState();
}

class _WorkShopHomeScreenState extends State<WorkShopHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<WorkShopsItemsProvider>(context, listen: false).getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          startNewScreenWithRoot(context, AddItemScreen(), true);
        },
        backgroundColor: getPrimaryColor(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
                child: Icon(Icons.logout),
              ))
        ],
      ),
      body: SafeArea(
        child: Consumer<WorkShopsItemsProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? Center(child: LottieAnimationWidget(MyAnimations.loader))
                : provider.items.isEmpty
                    ? Center(child: LottieAnimationWidget(MyAnimations.empty))
                    : BaseListView<Item>(
                        provider.items,
                        scrollable: true,
                        baseListWidgetBuilder: (data, pos) {
                          return InkWell(
                            onTap: () {},
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
                                        height: 70,
                                        width: 70),
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
                                          Text("Rs: ${data.price}",
                                              style: titleRegular.copyWith(
                                                  color: getTitleColor(context,
                                                      opacity: 0.7))),
                                          Text("Total Qty: ${data.totalqty}",
                                              style: titleRegular.copyWith(
                                                  color: getTitleColor(context,
                                                      opacity: 0.7))),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                            child: const Icon(
                                              Icons.edit,
                                              color: ColorResources.RED,
                                            ),
                                            onTap: () {
                                              startNewScreenWithRoot(
                                                  context,
                                                  AddItemScreen(item: data),
                                                  true);
                                            }),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        InkWell(
                                            child: const Icon(Icons.delete,
                                                color: ColorResources.RED),
                                            onTap: () {
                                              confirmationDialog(context,
                                                  "Are you sure you want to delete item?",
                                                  onCancel: () {
                                                popWidget(context);
                                              }, onYes: () {
                                                popWidget(context);

                                                getProvider<WorkShopsItemsProvider>(
                                                        context)
                                                    .deleteItem(context, data);
                                              });
                                            }),
                                      ],
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
