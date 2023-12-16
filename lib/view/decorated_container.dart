import 'package:flutter/material.dart';
import 'package:workshop/utils/utils.dart';

import '../utils/color_resources.dart';

// ignore: must_be_immutable
class DecoratedContainer extends StatelessWidget {
  Widget child;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;

  DecoratedContainer(
      {super.key, required this.child, this.margin, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 6,
                color: isDarkMode(context)
                    ? ColorResources.WHITE.withOpacity(0.9)
                    : ColorResources.DARK_GREY.withOpacity(0.3),
                spreadRadius: 5)
          ]),
      child: child,
    );
  }
}
