import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/utils.dart';

class LottieAnimationWidget extends StatelessWidget {
  String animationFile;
  String message = "";
  double height = 0, width = 0;

  LottieAnimationWidget(this.animationFile,
      {Key? key, this.message = "", this.width = 0, this.height = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height != 0 ? height : getScreenHeight(context) / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              animationFile,
              // width: width != 0 ? width : getScreenWidth(context) / 1.8,
              height: width != 0 ? width : getScreenWidth(context) / 1.8,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
