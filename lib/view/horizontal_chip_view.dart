import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/color_resources.dart';
import '../utils/custom_style.dart';
import '../utils/dimensions.dart';
import '../utils/utils.dart';

class HorizontalChipsWidget extends StatelessWidget {
  List<dynamic> list;
  List<String>? selected;
  Color? backgroundColor, textColor, selectedBackgroudColor;

  Function? onSelection;

  HorizontalChipsWidget(
      {required this.list,
      this.selected,
      this.backgroundColor,
      this.onSelection,
      this.selectedBackgroudColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: getBouncingScrollPhysics(),
      child: Row(
        children: list.map((e) {
          return InkWell(
            onTap: () {
              if (onSelection != null) {
                onSelection!(e.toString());
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: selected != null && selected!.contains(e.toString())
                    ? selectedBackgroudColor
                    : backgroundColor ??
                        ColorResources.DARK_GREY.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: Text(
                e.toString(),
                style: titleRegular.copyWith(
                    color: textColor ?? ColorResources.WHITE.withOpacity(0.8),
                    fontSize: Dimensions.FONT_SIZE_SMALL),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
