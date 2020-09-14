import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:http/http.dart' as http;

class sendHisaab {
  String number;
  String name;
  String hisaabBody;
  String sharefPrefKey;

  sendHisaab(this.sharefPrefKey);

  sendSMS() async {
    String body = await createBody();
    FlutterOpenWhatsapp.sendSingleMessage(number, body);
  
  }

  createBody () async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map customerData = jsonDecode(pref.getString(sharefPrefKey));
    List customerHisaabData = jsonDecode(pref.getString("HI"+sharefPrefKey));

    number = customerData["number"];
    name = customerData['name'];
    

    String total = customerData['total'];
    String smsBody = "Fazle Rabbi Monthly Receipt\nName: ${name}\nNumber: ${number}\n\nDate\t -> Litre\t -> Price\n";

    customerHisaabData.forEach((element) {
      smsBody += "${element['date']}\t -> ${element['amount']}\t ->  ${element['price']}\n";
    });

    smsBody += "\n\Monthly Amount: ${total}\nAdvance: 0\nTotal Amount: ${total}";

    return smsBody;
  }
}
