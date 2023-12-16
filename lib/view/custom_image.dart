import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workshop/utils/MyImages.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final BoxFit fit;
  final bool isNotification;
  bool isCircleImage ;

  CustomImage(
      {required this.image,
      required this.height,
        this.isCircleImage = true,
      required this.width,
      this.fit = BoxFit.cover,
      this.isNotification = false});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: !isCircleImage  ?  null :  (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(image: imageProvider),
          ),
        );
      },
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) =>
          Image.asset(avatarImage, height: height, fit: fit),
      errorWidget: (context, url, error) =>
          Image.asset(avatarImage, height: height, width: width, fit: fit),
    );
  }
}
