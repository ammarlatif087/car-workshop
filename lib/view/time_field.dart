import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';

import '../utils/color_resources.dart';
import '../utils/custom_style.dart';
import '../utils/utils.dart';

typedef OnDateSelected = Function(DateTime date);

class CustomTimeField extends StatefulWidget {
  String hintText = "";
  OnTimeSelected onTimeSelected;
  Time timeOfDay;
  bool editable;

  CustomTimeField(this.hintText, this.onTimeSelected, this.timeOfDay,
      {Key? key, this.editable = true})
      : super(key: key);

  @override
  State<CustomTimeField> createState() => _CustomTimeFieldState();
}

class _CustomTimeFieldState extends State<CustomTimeField> {
  TextEditingController textEditingController = TextEditingController();

  void setTimeInTextField() {
    textEditingController.text =
        getUserFormattedTime(getFormattedTime(widget.timeOfDay));
  }

  @override
  void initState() {
    super.initState();
    setTimeInTextField();
  }

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            widget.editable ? Theme.of(context).cardColor : ColorResources.GREY,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1)) // changes position of shadow
        ],
      ),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: TextInputType.text,
        //keyboardType: TextInputType.number,
        initialValue: null,
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            child: Icon(
              Icons.access_time_filled_sharp,
              color: widget.editable
                  ? ColorResources.PRIMARY_MATERIAL
                  : ColorResources.DARK_GREY,
            ),
            onTap: () {
              if (widget.editable) {
                showMyTimePicker(
                  context,
                  widget.timeOfDay,
                  (selected) {
                    setState(() {
                      widget.timeOfDay = selected;
                      setTimeInTextField();
                    });
                    widget.onTimeSelected(widget.timeOfDay);
                  },
                );
              }
            },
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          isDense: true,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          hintStyle:
              titilliumRegular.copyWith(color: Theme.of(context).hintColor),
          errorStyle: const TextStyle(height: 1.5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
