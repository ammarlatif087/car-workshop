import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/base_view/base_list_view.dart';
import 'package:workshop/base_view/custom_button.dart';
import 'package:workshop/model/item_model.dart';
import 'package:workshop/model/service_schedule_model.dart';
import 'package:workshop/provider/vehicles_provider.dart';
import 'package:workshop/provider/workshop_items_provider.dart';
import 'package:workshop/utils/color_resources.dart';
import 'package:workshop/utils/custom_style.dart';
import 'package:workshop/utils/utils.dart';
import 'package:workshop/view/custom_image_picker.dart';
import 'package:workshop/view/time_field.dart';

import '../model/service.dart';
import '../view/custom_text_field.dart';

// ignore: must_be_immutable
class AddVehicleModelScreen extends StatefulWidget {
  ServiceSchedule? item;

  AddVehicleModelScreen({super.key, this.item});

  @override
  State<AddVehicleModelScreen> createState() => _AddVehicleModelScreenState();
}

class _AddVehicleModelScreenState extends State<AddVehicleModelScreen> {
  TextEditingController modelNo = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.item != null) {
      modelNo.text = widget.item!.modelNo;
      selectedDays = widget.item!.days;
      selectedServices = widget.item!.services;

      servicesV2 = widget.item!.servicesV2;

      print(widget.item!.startTime + "  " + widget.item!.endTime.toString());

      List<String> startTimeList = widget.item!.startTime.split(":");
      List<String> endTimeList = widget.item!.endTime.split(":");

      startTime = Time(
          hour: int.parse(startTimeList[0]),
          minute: int.parse(startTimeList[1]));
      endTime = Time(
          hour: int.parse(endTimeList[0]), minute: int.parse(endTimeList[1]));
    }
  }

  List<dynamic> selectedServices = [];
  List<dynamic> selectedDays = [];
  Time startTime = Time.fromTimeOfDay(TimeOfDay.now(), 0);
  Time endTime = Time.fromTimeOfDay(TimeOfDay.now(), 0);
  List<Service> servicesV2 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.item == null ? "Add Service Schedule" : "Update Item",
          style: titleHeader.copyWith(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getWidthMargin(context, 3)),
        child: SingleChildScrollView(
          physics: getBouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getWidthMargin(context, 5)),

              Text(
                "Service Timing",
                style: titleHeader.copyWith(
                    color: ColorResources.DARK_GREY.withOpacity(0.7)),
              ),

              SizedBox(
                height: getWidthMargin(context, 2),
              ),
              Row(
                children: [
                  Expanded(
                      child: CustomTimeField("Start Time", (selected) {
                    setState(() {
                      startTime = selected;
                    });
                  }, startTime)),
                  SizedBox(width: getWidthMargin(context, 1)),
                  Expanded(
                      child: CustomTimeField("End Time", (selected) {
                    setState(() {
                      endTime = selected;
                    });
                  }, endTime)),
                ],
              ),

              SizedBox(height: getWidthMargin(context, 5)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Service Types",
                    style: titleHeader.copyWith(
                        color: ColorResources.DARK_GREY.withOpacity(0.7)),
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.add,
                      color: ColorResources.GRAY,
                    ),
                    onTap: () {
                      TextEditingController nameController =
                          TextEditingController();
                      TextEditingController rateController =
                          TextEditingController();
                      Container container = Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Column(
                          children: [
                            CustomTextField(
                                textEditingController: nameController,
                                hintText: "Enter Service Name"),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                                textEditingController: rateController,
                                textInputType: TextInputType.number,
                                hintText: "Enter Rate")
                          ],
                        ),
                      );
                      confirmationDialog(context, "",
                          title: "Add Service", onCancel: () {}, onYes: () {
                        if (nameController.text.isEmpty) {
                          infoSnackBar(context, "Please enter service name");
                          return;
                        }
                        if (rateController.text.isEmpty) {
                          infoSnackBar(context, "Please enter service rate");
                          return;
                        }
                        double rate = double.parse(rateController.text);
                        if (rate == 0) {
                          infoSnackBar(context, "Please enter service rate");
                          return;
                        }
                        Service service = Service(nameController.text, rate);
                        servicesV2.add(service);
                        popWidget(context);
                        setState(() {});
                      }, yesButtonText: "Add", widget: container);
                    },
                  )
                ],
              ),

              BaseListView(
                servicesV2,
                baseListWidgetBuilder: (data, pos) {
                  return InkWell(
                    onTap: () {
                      TextEditingController nameController =
                          TextEditingController();
                      TextEditingController rateController =
                          TextEditingController();

                      nameController.text = data.name;
                      rateController.text = data.rate.toString();
                      Container container = Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Column(
                          children: [
                            CustomTextField(
                                textEditingController: nameController,
                                hintText: "Enter Service Name"),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                                textEditingController: rateController,
                                textInputType: TextInputType.number,
                                hintText: "Enter Rate")
                          ],
                        ),
                      );
                      confirmationDialog(context, "",
                          title: "Update Service", onCancel: () {}, onYes: () {
                        if (nameController.text.isEmpty) {
                          infoSnackBar(context, "Please enter service name");
                          return;
                        }
                        if (rateController.text.isEmpty) {
                          infoSnackBar(context, "Please enter service rate");
                          return;
                        }
                        double rate = double.parse(rateController.text);
                        if (rate == 0) {
                          infoSnackBar(context, "Please enter service rate");
                          return;
                        }
                        Service service = Service(nameController.text, rate);
                        data.name = service.name;
                        data.rate = service.rate;
                        popWidget(context);
                        setState(() {});
                      }, yesButtonText: "Update", widget: container);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                style: titleHeader,
                              ),
                              Text(
                                "Rs: ${data.rate}",
                                style: titleRegular,
                              ),
                            ],
                          ),
                          InkWell(
                              child: const Icon(
                                Icons.delete,
                                color: ColorResources.RED,
                              ),
                              onTap: () {
                                servicesV2.remove(data);
                                setState(() {});
                              }),
                        ],
                      ),
                    ),
                  );
                },
                scrollable: false,
                shrinkable: true,
                baseListSeparatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                  );
                },
              ),

              // ChipsChoice<String>.multiple(
              //   choiceItems: getServiceTypes()
              //       .map((e) =>
              //           C2Choice(value: e.toString(), label: e.toString()))
              //       .toList(),
              //   onChanged: (List<String> selected) {
              //     setState(() {
              //       selectedServices = selected;
              //     });
              //   },
              //   choiceCheckmark: true,
              //   value: selectedServices.map((e) => e.toString()).toList(),
              // ),
              // SizedBox(height: getWidthMargin(context, 5)),

              Text(
                "Working Days",
                style: titleHeader.copyWith(
                    color: ColorResources.DARK_GREY.withOpacity(0.7)),
              ),

              ChipsChoice<String>.multiple(
                choiceItems: getWeekDays()
                    .map((e) =>
                        C2Choice(value: e.toString(), label: e.toString()))
                    .toList(),
                onChanged: (List<String> selected) {
                  setState(() {
                    selectedDays = selected;
                  });
                },
                choiceCheckmark: true,
                value: selectedDays.map((e) => e.toString()).toList(),
              ),

              // CustomTextField(
              //   textEditingController: nameController,
              //   hintText: "Enter Name",
              // ),
              SizedBox(height: getWidthMargin(context, 2)),
              CustomTextField(
                textInputType: TextInputType.multiline,
                textEditingController: modelNo,
                hintText: "Enter Model No",
              ),
              SizedBox(height: getWidthMargin(context, 5)),
              Center(
                child: CustomButton(
                  text: widget.item == null ? 'Save Schedule' : "Update Item",
                  color: getPrimaryColor(context),
                  onClick: () {
                    String modelNoString = modelNo.text.toString();
                    String startTimeString = getFormattedTime(startTime);
                    String endTimeString = getFormattedTime(endTime);
                    if (startTimeString == endTimeString) {
                      infoSnackBar(
                          context, "Start time and end time must not be same!");
                      return;
                    }
                    if (servicesV2.isEmpty) {
                      infoSnackBar(context, "Please add least one service");
                      return;
                    }
                    if (selectedDays.isEmpty) {
                      infoSnackBar(context, "Please select at least one day");
                      return;
                    }

                    if (modelNoString.isEmpty) {
                      infoSnackBar(context, "Please enter model no!");
                      return;
                    }

                    ServiceSchedule vehicle;
                    if (widget.item != null) {
                      vehicle = widget.item!;
                      vehicle.modelNo = modelNoString;
                      vehicle.startTime = startTimeString;
                      vehicle.endTime = endTimeString;
                      vehicle.days = selectedDays;
                      vehicle.services = selectedServices;
                      Provider.of<VehiclesProvider>(context, listen: false)
                          .updateItem(context, vehicle);
                    } else {
                      vehicle = ServiceSchedule(
                          modelNo: modelNoString,
                          days: selectedDays,
                          endTime: endTimeString,
                          startTime: startTimeString,
                          services: selectedServices);

                      vehicle.servicesV2 = servicesV2;
                      vehicle.userId = getUserId();
                      Provider.of<VehiclesProvider>(context, listen: false)
                          .addVehicle(context, vehicle);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
