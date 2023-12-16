
import 'package:flutter/material.dart';
import 'package:workshop/utils/utils.dart';

import '../utils/color_resources.dart';
import '../utils/custom_style.dart';

class HeaderTitleTextWidget extends StatelessWidget {
  String title;

  HeaderTitleTextWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: getWidthMargin(context, 3)),
      width: getScreenWidth(context),
      color: ColorResources.DARK_GREY.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: titleHeaderExtra.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}