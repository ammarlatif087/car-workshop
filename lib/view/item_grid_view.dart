import 'package:flutter/cupertino.dart';
import 'package:workshop/utils/utils.dart';

import '../model/item_model.dart';
import 'item_widget.dart';

class ItemGridView extends StatelessWidget {
  bool isScrollable;
  List<Item> items;

  ItemGridView(this.isScrollable, this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      physics: getBouncingScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // mainAxisExtent: 0.1
          childAspectRatio: .55),
      // gridDelegate:
      //     const Sliver(crossAxisCount: 2,),
      childrenDelegate: SliverChildBuilderDelegate((context, index) {
        return ItemWidget(
          item: items[index],
        );
      }, childCount: items.length),
    );
  }
}
