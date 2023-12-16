import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/main.dart';
import 'package:workshop/model/booking_model.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/provider/user_bookings_provider.dart';
import 'package:workshop/provider/workshop_bookings_provider.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/my_animations.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image.dart';
import 'package:workshop/view/custom_image_picker.dart';
import 'package:workshop/view/loader_view.dart';

import '../model/service.dart';
import '../model/user.dart';
import '../utils/color_resources.dart';
import 'horizontal_chip_view.dart';

// ignore: must_be_immutable
class WorkshopBookingDetailScreen extends StatefulWidget {
  ServiceSchedule serviceSchedule;
  BookingModel? bookingModel;
  bool viewOnly;
  bool forWorkshop;

  // List<Service> selectedServices = [];

  WorkshopBookingDetailScreen(
      {super.key,
      required this.serviceSchedule,
      this.forWorkshop = false,
      this.bookingModel,
      this.viewOnly = false});

  @override
  State<WorkshopBookingDetailScreen> createState() =>
      _WorkshopBookingDetailScreenState();
}

class _WorkshopBookingDetailScreenState
    extends State<WorkshopBookingDetailScreen> {
  User? workshop;

  List<String> selectedDays = [];
  List<String> selectedServices = [];
  String selectedImage = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      DataSnapshot dataSnapshot = await firebaseDatabase
          .ref("Users")
          .child(widget.forWorkshop
              ? widget.bookingModel!.userId
              : widget.serviceSchedule.userId)
          .get();

      Map<dynamic, dynamic>? json = dataSnapshot.value as Map?;
      if (json != null) {
        workshop = User.fromJson(json);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WorkshopBookingsProvider provider =
        getProvider<WorkshopBookingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Booking Details",
          style: titleHeader.copyWith(color: Colors.white),
        ),
      ),
      bottomNavigationBar: widget.viewOnly
          ? null
          : Container(
              width: getScreenWidth(context),
              margin: EdgeInsets.symmetric(
                  horizontal: getWidthMargin(context, 5),
                  vertical: getWidthMargin(context, 2)),
              child: widget.forWorkshop
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.forWorkshop &&
                                widget.bookingModel!.status == "Pending"
                            ? SizedBox(
                                height: getWidthMargin(context, 3),
                              )
                            : const SizedBox.shrink(),
                        widget.forWorkshop &&
                                widget.bookingModel!.status == "Pending"
                            ? Column(
                                children: [
                                  CustomButton(
                                      text: "Confirm",
                                      color: ColorResources.GREEN,
                                      onClick: () {
                                        confirmationDialog(context,
                                            "Are you sure you want to confirm this order?",
                                            onCancel: () {
                                          popWidget(context);
                                        }, onYes: () {
                                          provider.updateBooking(
                                              context,
                                              widget.bookingModel!,
                                              "Confirmed");
                                        });
                                      }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomButton(
                                      text: "Cancel",
                                      color: ColorResources.RED,
                                      onClick: () {
                                        confirmationDialog(context,
                                            "Are you sure you want to cancel this order?",
                                            onCancel: () {
                                          popWidget(context);
                                        }, onYes: () {
                                          provider.updateBooking(
                                              context,
                                              widget.bookingModel!,
                                              "Cancelled");
                                        });
                                      }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink()
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Upload Attachment here"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImagePicker(
                                isAttachmentPicker: true,
                                imagePickerCallback: (path) {
                                  selectedImage = path;
                                  setState(() {});
                                },
                                selectedImage: selectedImage),
                          ],
                        ),
                        CustomButton(
                            text: "Book This Service",
                            color: getPrimaryColor(context),
                            onClick: () {
                              List<Service> services = [];
                              for (var e in widget.serviceSchedule.servicesV2) {
                                for (var element in selectedServices) {
                                  if (element == "${e.name} Rs:${e.rate}") {
                                    services.add(e);
                                  }
                                }
                              }

                              if (services.isEmpty) {
                                infoSnackBar(context,
                                    "Please select at least one service!");
                                return;
                              }

                              if (selectedDays.isEmpty) {
                                infoSnackBar(
                                    context, "Please select day for booking!");
                                return;
                              }

                              if (selectedImage.isEmpty) {
                                infoSnackBar(
                                    context, "Please select attachment");
                                return;
                              }

                              confirmationDialog(context,
                                  "Are you sure you want to book this service",
                                  onCancel: () {
                                popWidget(context);
                              }, onYes: () {
                                BookingModel bookingModel = BookingModel();
                                bookingModel.serviceSchedule =
                                    widget.serviceSchedule;
                                bookingModel.selectedDay = selectedDays[0];
                                bookingModel.bookingTime = getCurrentTime();
                                bookingModel.bookingDate = getCurrentDate();
                                bookingModel.userId = getUserId();
                                bookingModel.workshopId =
                                    widget.serviceSchedule.userId;
                                bookingModel.services = services;

                                getProvider<UserBookingsProvider>(context)
                                    .addBooking(
                                        context, bookingModel, selectedImage);
                              });
                            }),
                      ],
                    ),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: getBouncingScrollPhysics(),
          child: workshop == null
              ? LottieAnimationWidget(MyAnimations.loader)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.forWorkshop
                        ? const SizedBox.shrink()
                        : const SizedBox(
                            height: 10,
                          ),
                    !widget.forWorkshop
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CustomImage(
                                    image: workshop!.imageUrl,
                                    height: 60,
                                    width: 60),
                                SizedBox(
                                  width: getWidthMargin(context, 3),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      workshop!.name,
                                      style: titleRegular.copyWith(
                                          color: ColorResources.DARK_GREY),
                                    ),
                                    Text(
                                      workshop!.address,
                                      style: titleRegular.copyWith(
                                          color: ColorResources.DARK_GREY
                                              .withOpacity(0.5)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                    widget.forWorkshop
                        ? const SizedBox.shrink()
                        : CustomImage(
                            image: workshop!.imageUrl.toString(),
                            height: getScreenHeight(context) / 3,
                            width: getScreenWidth(context)),
                    widget.forWorkshop
                        ? const SizedBox.shrink()
                        : _TitleTextWidget(
                            title: "Workshop Name",
                            text: workshop!.name.toString()),
                    widget.forWorkshop
                        ? const SizedBox.shrink()
                        : const SizedBox(
                            height: 5,
                          ),
                    widget.forWorkshop
                        ? const SizedBox.shrink()
                        : _TitleTextWidget(
                            title: "Workshop Address",
                            text: workshop!.address.toString()),
                    widget.forWorkshop
                        ? const SizedBox.shrink()
                        : _TitleTextWidget(
                            title: "Bank Name",
                            text: workshop!.bname.toString()),
                    widget.forWorkshop
                        ? const SizedBox.shrink()
                        : _TitleTextWidget(
                            title: "Account Number",
                            text: workshop!.acno.toString()),
                    widget.forWorkshop
                        ? const SizedBox.shrink()
                        : _TitleTextWidget(
                            title: "Cnic Number",
                            text: workshop!.cnic.toString()),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _TitleTextWidget(
                        title: "Model", text: widget.serviceSchedule.modelNo),
                    const SizedBox(
                      height: 5,
                    ),
                    _TitleTextWidget(
                        title: "Start Time",
                        text: getUserFormattedTime(
                            widget.serviceSchedule.startTime)),
                    const SizedBox(
                      height: 5,
                    ),
                    _TitleTextWidget(
                        title: "End Time",
                        text: getUserFormattedTime(
                            widget.serviceSchedule.endTime)),
                    SizedBox(
                      height: getWidthMargin(context, 5),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidthMargin(context, 3)),
                      child: Text(
                        "Services",
                        style: titleHeader.copyWith(
                            color: ColorResources.DARK_GREY),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    widget.bookingModel != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidthMargin(context, 3)),
                            child: HorizontalChipsWidget(
                                list: widget.bookingModel!.services
                                    .map((e) => "${e.name} Rs:${e.rate}")
                                    .toList(),
                                backgroundColor: getPrimaryColor(context),
                                textColor: Colors.white),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidthMargin(context, 3)),
                            child: HorizontalChipsWidget(
                                list: widget.serviceSchedule.servicesV2
                                    .map((e) => "${e.name} Rs:${e.rate}")
                                    .toList(),
                                onSelection: (e) {
                                  selectedServices.add(e);
                                  setState(() {});
                                },
                                selected: selectedServices,
                                selectedBackgroudColor: Colors.green,
                                backgroundColor: getPrimaryColor(context),
                                textColor: Colors.white),
                          ),
                    SizedBox(
                      height: getWidthMargin(context, 5),
                    ),
                    widget.bookingModel == null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidthMargin(context, 3)),
                            child: Text(
                              "Available Days",
                              style: titleHeader.copyWith(
                                  color: ColorResources.DARK_GREY),
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 5,
                    ),
                    widget.bookingModel != null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidthMargin(context, 3)),
                            child: HorizontalChipsWidget(
                                list: widget.serviceSchedule.days,
                                selected: widget.viewOnly ? [] : selectedDays,
                                selectedBackgroudColor: widget.viewOnly
                                    ? null
                                    : ColorResources.GREEN,
                                onSelection: widget.viewOnly
                                    ? null
                                    : (selected) {
                                        selectedDays.clear();
                                        selectedDays.add(selected.toString());
                                        setState(() {});
                                      },
                                backgroundColor: getPrimaryColor(context),
                                textColor: Colors.white),
                          ),
                    widget.bookingModel == null
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              const Divider(
                                thickness: 2,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              _TitleTextWidget(
                                  title: "Booking Date",
                                  text: widget.bookingModel!.bookingDate),
                              const SizedBox(
                                height: 3,
                              ),
                              _TitleTextWidget(
                                  title: "Booking Time",
                                  text: widget.bookingModel!.bookingTime),
                              const SizedBox(
                                height: 3,
                              ),
                              _TitleTextWidget(
                                  title: "Selected Day",
                                  text: widget.bookingModel!.selectedDay),
                              const SizedBox(
                                height: 3,
                              ),
                              _TitleTextWidget(
                                  title: "Booking Status",
                                  text: widget.bookingModel!.status,
                                  valueColor:
                                      widget.bookingModel!.getStatusColor()),
                              const SizedBox(
                                height: 3,
                              ),
                              widget.bookingModel!.proofUrl.isNotEmpty
                                  ? CustomImage(
                                      image: widget.bookingModel!.proofUrl,
                                      height: 200,
                                      width: 200)
                                  : const SizedBox.shrink(),
                            ],
                          )
                  ],
                ),
        ),
      ),
    );
  }
}

class _TitleTextWidget extends StatelessWidget {
  String title, text;

  Color? valueColor;

  _TitleTextWidget({required this.title, required this.text, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleHeader.copyWith(color: ColorResources.DARK_GREY),
          ),
          Text(
            text,
            style: titleHeader.copyWith(
                color: valueColor ?? ColorResources.DARK_GREY.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
