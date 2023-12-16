import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/provider/workshop_items_provider.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image_picker.dart';

import '../view/custom_text_field.dart';

// ignore: must_be_immutable
class AddItemScreen extends StatefulWidget {
  Item? item;

  AddItemScreen({super.key, this.item});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController detailsController = TextEditingController();

  TextEditingController priceController = TextEditingController();
  TextEditingController totalQtyCtrl = TextEditingController();

  String selectedImage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.item != null) {
      nameController.text = widget.item!.name;
      detailsController.text = widget.item!.description.toString();
      priceController.text = widget.item!.price.toString();
      totalQtyCtrl.text = widget.item!.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.item == null ? "Add Item" : "Update Item",
          style: titleHeader.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 3)),
        child: SingleChildScrollView(
          physics: getBouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: getWidthMargin(context, 5)),
              CustomImagePicker(
                  networkImage:
                      widget.item != null ? widget.item!.imageUrl : "",
                  imagePickerCallback: (path) {
                    selectedImage = path;
                    setState(() {});
                  },
                  selectedImage: selectedImage),
              SizedBox(height: getWidthMargin(context, 5)),
              CustomTextField(
                textEditingController: nameController,
                hintText: "Enter Name",
              ),
              SizedBox(height: getWidthMargin(context, 2)),
              CustomTextField(
                textInputType: TextInputType.multiline,
                textEditingController: detailsController,
                hintText: "Enter Details",
              ),
              SizedBox(height: getWidthMargin(context, 2)),
              CustomTextField(
                textInputType: TextInputType.number,
                textEditingController: priceController,
                hintText: "Enter Price",
              ),
              SizedBox(height: getWidthMargin(context, 5)),
              CustomTextField(
                textInputType: TextInputType.number,
                textEditingController: totalQtyCtrl,
                hintText: "Total qty",
              ),
              SizedBox(height: getWidthMargin(context, 5)),
              CustomButton(
                text: widget.item == null ? 'Add Item' : "Update Item",
                color: getPrimaryColor(context),
                onClick: () {
                  String name, details, price, totalQty;
                  name = nameController.text.toString();
                  details = detailsController.text.toString();
                  price = priceController.text.toString();
                  totalQty = totalQtyCtrl.text.toString();

                  if (name.isEmpty) {
                    infoSnackBar(context, "Enter Name");
                    return;
                  }

                  if (totalQty.isEmpty) {
                    infoSnackBar(context, "Enter qty");
                    return;
                  }
                  if (details.isEmpty) {
                    infoSnackBar(context, "Enter Details");
                    return;
                  }
                  if (price.isEmpty) {
                    infoSnackBar(context, "Enter Price");
                    return;
                  }
                  double priceDouble = double.parse(price);
                  if (priceDouble == 0) {
                    infoSnackBar(context, "Enter Price");
                    return;
                  }
                  if (widget.item == null) {
                    Item item = Item(name: name, description: details);
                    item.price = priceDouble;
                    item.userId = getUserId();
                    item.totalqty = totalQty;

                    Provider.of<WorkShopsItemsProvider>(context, listen: false)
                        .addItem(context, item, file: File(selectedImage));
                  } else {
                    widget.item!.name = name;
                    widget.item!.description = details;
                    widget.item!.price = priceDouble;
                    widget.item!.totalqty = totalQty;

                    Provider.of<WorkShopsItemsProvider>(context, listen: false)
                        .updateItem(context, widget.item!,
                            file: selectedImage.isEmpty
                                ? null
                                : File(selectedImage));
                  }
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
