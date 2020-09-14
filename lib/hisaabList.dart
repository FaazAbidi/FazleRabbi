import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';


 class HisaabList {
  String litre;
  List<Map> hisaabTable;
  List<DateTime> dates;
  String userTotal;
  String litrePrice;

  HisaabList(this.litre);

  createMap (List datesRange) async {
    int counter = 0;
    DateTime incrementDate = datesRange[0];
    DateTime startingDate = datesRange[0];
    List<Map> listOfmaps = [];

    SharedPreferences pref = await SharedPreferences.getInstance();
    litrePrice = pref.getString("Slitreprice");

    if (datesRange.length == 1) {
      List eachDate = [{
        'date' : DateFormat('EEE, MMM d, ''yy').format(datesRange[0]),
        'amount': "${litre} Litres",
        'price' : "Rs. ${((double.parse(litre) * double.parse(litrePrice == null ? "0" : litrePrice)).round()).toString()}"
      }];

      return eachDate;
    }

    while (incrementDate  != datesRange[1]) {

      Map eachDate = {
        'date' : DateFormat('EEE, MMM d, ''yy').format(new DateTime(startingDate.year, startingDate.month, startingDate.day + counter)),
        'amount': "${litre} Litres",
        'price' : "Rs. ${((double.parse(litre) * double.parse(litrePrice == null ? "0" : litrePrice)).round()).toString()}"
      };
      listOfmaps.add(eachDate);

      incrementDate = new DateTime(startingDate.year, startingDate.month, startingDate.day + counter);
      counter += 1;
    }

    return listOfmaps;
  }

  hissabDateRow (List listOfMaps) {
    List <DataRow> returnList = [];
    listOfMaps.forEach((element) {
      returnList.add(getDataRow(element));
    });

    return returnList;
  }


  getDataRow (Map each) {
    return  
    DataRow(
      cells: [
        DataCell(
          InkWell(child: Text(each['amount']),
          onTap: () {
            // have to add single delete functionality
          },
          ),
          
        ),
        DataCell(
          Text(each['price']),
        ),
        DataCell(
          Text(each['date']),   
        )
      ]);
  }


  saveHisaabtoSharedPref (List hisaabList, String sharedIndex) async {

    String rawJson = jsonEncode(hisaabList);
    SharedPreferences pref = await SharedPreferences.getInstance();
    // HI represents that this is a hisaab list
    pref.setString("HI"+sharedIndex, rawJson);
  }

  getCustomerTotal (List customDates, sharedIndex)  {

    double sum = 0;

    customDates.forEach((element) {
      sum += double.parse(element["price"].substring(4));
    });

    return sum;

  }

}