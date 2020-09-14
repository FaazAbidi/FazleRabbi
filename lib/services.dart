import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:fazle_rabbi/hisaabList.dart';



class FServices {
  Color green_accent_color = Color.fromRGBO(221, 235, 231, 1);
  double height = window.physicalSize.height / window.devicePixelRatio;
  double width = window.physicalSize.width / window.devicePixelRatio;
  Map customerInfo;
  String displayDateStr = 'Pick a date';
  String litre;
  List<DateTime> customDates;

  BuildContext context;

  showToastMessage(
    context,
    msg,
  ) {
    return Fluttertoast.showToast(
        msg: msg,
        fontSize: 15,
        textColor: Theme.of(context).accentColor,
        backgroundColor: green_accent_color);
  }
}
