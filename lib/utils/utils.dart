import 'dart:io';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workshop/api/callbacks.dart';
import 'package:workshop/main.dart';
import 'package:workshop/utils/custom_route.dart';
import 'package:workshop/utils/dimensions.dart';

import 'color_resources.dart';

List<String> colorList = [
  "E59866",
  "6462E0",
  "E06279",
  "E062DE",
  "776CA6",
  "797E93",
  "0B6287",
  "83D2C8",
  "83D29A",
  "C2C952",
  "6B4949",
];

BouncingScrollPhysics getBouncingScrollPhysics() {
  return const BouncingScrollPhysics();
}

void infoSnackBar(BuildContext context, String message) {
  snakeBar(context, message, ColorResources.BLUE);
}

String getWithZero(int number) {
  if (number < 0) {
    return "0$number";
  }
  return "$number";
}

void snakeBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: color,
    elevation: 5,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.symmetric(
        vertical: Dimensions.MARGIN_SIZE_LARGE,
        horizontal: Dimensions.MARGIN_SIZE_LARGE),
  ));
}

void showLoadingDialog(String message) {
  EasyLoading.show(status: message);
}

void dismissLoadingDialog() {
  EasyLoading.dismiss();
}

String getUserId() {
  return auth.currentUser!.uid;
}

String getFormattedTime(Time timeOfDay) {
  String hours = getWithZero(timeOfDay.hour);
  String minutes = getWithZero(timeOfDay.minute);
  return "$hours:$minutes:00";
}

typedef OnTimeSelected = Function(Time selected);

void showMyTimePicker(
    BuildContext context, Time timeOfDay, OnTimeSelected onChange) {
  // timeOfDay  Time(hour: 6, minute: 00);
  Navigator.of(context).push(
    showPicker(
      context: context,
      value: timeOfDay,
      onChange: (Time day) {
        onChange(day);
      },
      // onChange: onChange,
    ),
  );
}

List<String> getServiceTypes() {
  return [
    "Repairing",
    "Inspection",
    "Tuning",
    "Oil Change",
    "Brake Inspection",
    "Denting And Painting",
    "Suspension",
  ];
}

List<String> getWeekDays() {
  return [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
}

void uploadFile(String folderName, File filePath,
    {required OnSuccessCallback<String> onSuccessCallback,
    required OnErrorCallback onErrorCallback}) {
  UploadTask uploadTask = firebaseStorage
      .ref("$folderName/${DateTime.now().millisecondsSinceEpoch}")
      .putFile(filePath);

  uploadTask.snapshotEvents.listen((event) async {
    if (event.state == TaskState.success) {
      String url = await uploadTask.snapshot.ref.getDownloadURL();
      onSuccessCallback(url);
    } else if (event.state == TaskState.error) {
      onErrorCallback(event.state.name.toString());
    }
  });
}

RoundedRectangleBorder getCardShape(double radius) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  );
}

String getCurrentDate({int? nextDays}) {
  return getFormattedDate(nextDays == null
      ? DateTime.now()
      : DateTime.now().add(Duration(days: nextDays)));
}

String getCurrentTime() {
  var formatter = DateFormat('hh:mm:ss');
  return formatter.format(DateTime.now());
}

DateTime getDateTimeFromTime(String date) {
  var formatter = DateFormat('HH:mm:ss');
  DateTime dateTime = formatter.parse(date);
  return dateTime;
}

DateTime getDateTimeFromDate(String date) {
  var formatter = DateFormat('yyyy-MM-dd');
  DateTime dateTime = formatter.parse(date);
  return dateTime;
}

DateTime getDateTimeFromDateTimeString(String date) {
  var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateTime dateTime = formatter.parse(date);
  return dateTime;
}

String getMinutesIntoDuration(int minutes) {
  int hours = minutes ~/ 60;
  minutes = (minutes % 60);
  if (hours == 0) {
    return "$minutes Min";
  }
  if (minutes == 0) {
    return "$hours Hr";
  }
  return "$hours Hr $minutes Min";
}

String getTimeDifference(String startTime, String endTime) {
  DateTime old = getDateTimeFromTime(startTime);
  DateTime secondDateObject = getDateTimeFromTime(endTime);
  Duration duration = secondDateObject.difference(old);
  return getMinutesIntoDuration(duration.inMinutes);
}

Future pushUntil(BuildContext context, Widget widget) {
  return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}

Color getColorFromString(String code) {
  return Color(int.parse("0xff$code"));
}

void popWidget(BuildContext context) {
  Navigator.of(context).pop();
}

String getFormattedDate(DateTime date) {
  var formatter = DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(date);
  return formattedDate;
}

Future startNewScreenWithRoot(
    BuildContext context, Widget widget, bool rootNavigator) {
  return Navigator.of(context, rootNavigator: rootNavigator).push(MyCustomRoute(
    widget,
  ));
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getWidthMargin(BuildContext context, double percentage) {
  double width = getScreenWidth(context);
  return (width / 100) * percentage;
}

double getHeightMargin(BuildContext context, double percentage) {
  double width = getScreenHeight(context);
  return (width / 100) * percentage;
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Color getTitleColor(BuildContext context, {double opacity = 0.3}) {
  return Theme.of(context).brightness == Brightness.dark
      ? ColorResources.WHITE
      : ColorResources.DARK_GREY.withOpacity(opacity);
}

DotNavigationBarItem getBottomNavItem(String image) {
  return DotNavigationBarItem(
    icon: Image.asset(
      image,
      height: 20,
      width: 20,
    ),
  );
}

String getUserFormattedTime(String time) {
  var dateFormat = DateFormat("hh:mm:ss");
  return DateFormat("h:mm a").format(dateFormat.parse(time));
}

String getUserFormattedDate(String time) {
  var dateFormat = DateFormat("yyyy-MM-dd");
  return DateFormat.yMMMMd().format(dateFormat.parse(time));
}

void confirmationDialog(BuildContext context, String message,
    {required Function onCancel, required Function onYes, Widget? widget , String title = "Confirmation",String yesButtonText = "Yes"}) {
// set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title:  Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message),
        const SizedBox(
          height: 10,
        ),
        widget ?? const SizedBox.shrink()
      ],
    ),
    actions: [
      TextButton(
          onPressed: () {
            // if (buildContext != null) Navigator.pop(buildContext!);
            onCancel();
          },
          child: const Text(
            "No",
            style: TextStyle(color: ColorResources.PRIMARY_MATERIAL),
          )),
      TextButton(
          onPressed: () {
            // if (buildContext != null) Navigator.pop(buildContext!);
            onYes();
          },
          child:  Text(
            yesButtonText,
            style: TextStyle(color: ColorResources.PRIMARY_MATERIAL),
          )),
    ],
  );
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

T getProvider<T extends ChangeNotifier>(BuildContext context) {
  return Provider.of<T>(context, listen: false);
}

Color getPrimaryColor(BuildContext context) {
  return Theme.of(context).primaryColor;
}

// void showBottomSheetDatePicker(BuildContext context, DateTime selectedDate,
//     {required Function onSelected}) {
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return TableCalendar(
//           firstDay: DateTime.now(),
//           lastDay: DateTime.now().add(const Duration(days: 5000)),
//           focusedDay: DateTime.now(),
//           calendarFormat: CalendarFormat.month,
//           calendarStyle: CalendarStyle(
//             selectedDecoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               shape: BoxShape.circle,
//             ),
//             todayDecoration: BoxDecoration(
//               color: Colors.grey[300],
//               shape: BoxShape.circle,
//             ),
//           ),
//           selectedDayPredicate: (date) {
//             return isSameDay(selectedDate, date);
//           },
//           onDaySelected: (date, focusedDay) {
//             onSelected(date);
//             popWidget(context);
//           },
//           calendarBuilders: CalendarBuilders(
//             selectedBuilder: (context, date, _) => Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   date.day.toString(),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         );
//       });
// }
