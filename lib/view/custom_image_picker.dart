import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workshop/view/custom_image.dart';

import '../utils/MyImages.dart';
import '../utils/color_resources.dart';

typedef ImagePickerCallback = void Function(String path);

class CustomImagePicker extends StatefulWidget {
  ImagePickerCallback imagePickerCallback;
  String selectedImage;
  String networkImage;
  bool isAttachmentPicker = false;

  CustomImagePicker(
      {required this.imagePickerCallback,
      this.selectedImage = "",
      this.isAttachmentPicker = false,
      this.networkImage = ""});

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () async {
          ImagePicker imagePicker = ImagePicker();
          XFile? xFile =
              await imagePicker.pickImage(source: ImageSource.gallery);
          if (xFile != null) {
            widget.imagePickerCallback(xFile.path);
          }
        },
        child: widget.selectedImage.isNotEmpty
            ? Image.file(File(widget.selectedImage), width: 100, height: 100)
            : widget.networkImage.isNotEmpty
                ? CustomImage(
                    image: widget.networkImage, height: 100, width: 100)
                : widget.isAttachmentPicker
                    ? const Icon(
                        Icons.attachment,
                        size: 70,
                      )
                    : Image.asset(avatarImage, width: 100, height: 100),
      ),
    );
  }
}
