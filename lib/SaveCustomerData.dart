import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class SaveCustomer  {
  String name;
  String number;
  String address;
  List hisaab;
  String sharedPrefKey;

  SaveCustomer();

  saveDatainSharedPreference (@required sharedPrefKey, @required name, @required number, @required address, @required total) async {

    String lastupdated = getLastUpdatedTime();

    Map<dynamic, dynamic> customerData = {
      'key' : sharedPrefKey,
      'name' : name, 
      'number' : number, 
      'address': address,
      'total' : total,
      'last_edit' : lastupdated
    }; 

      String rawJson = jsonEncode(customerData);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString(sharedPrefKey, rawJson);
  }

      generateSharedKey<String> () async  {
        SharedPreferences pref = await SharedPreferences.getInstance();
        List <int> allKeys = [];
        pref.getKeys().forEach((element) {
          if (!element.contains("HI") && !element.contains("S")) {
            allKeys.add(int.parse(element));
          }

          // TEST THIS PART!!! Add more than one users. 
        });
        allKeys.sort();
        
        int maxKey = allKeys.length == 0 ? -1 : allKeys.last;
        return (maxKey+1).toString();

      }


      getLastUpdatedTime () {
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('hh:mm d MMM').format(now);
        return formattedDate;

      }

      updateCustomerTotalInSharedPref (sharedIndex, String total) async {

        SharedPreferences pref = await SharedPreferences.getInstance();
        Map customerData = jsonDecode(pref.getString(sharedIndex));

        pref.remove(sharedIndex);

        customerData['total'] = total;

        String rawJson = jsonEncode(customerData);
        pref.setString(sharedIndex, rawJson);
        
        
      }


}