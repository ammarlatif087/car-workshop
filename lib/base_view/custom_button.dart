import 'package:flutter/cupertino.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';

import '../utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  String text;
  Function onClick;
  Color color;
  Color? textColor;
  double textSize;

  CustomButton(
      {super.key,
      required this.text,
      required this.color,
      this.textColor,
      required this.onClick,
      this.textSize = Dimensions.FONT_SIZE_DEFAULT});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        onClick();
      },
      color: color,
      child: Text(
        text,
        style: titleRegular.copyWith(
            color: textColor ?? ColorResources.WHITE, fontSize: textSize),
      ),
    );
  }
}
