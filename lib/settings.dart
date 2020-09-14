import 'package:fazle_rabbi/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fazle_rabbi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color green_accent_color = Color.fromRGBO(221, 235, 231, 1);
  Color barTextColor = Color.fromRGBO(230, 232, 232, 1);
  double height = window.physicalSize.height / window.devicePixelRatio;
  double width = window.physicalSize.width / window.devicePixelRatio;
  String warningForclearHisaab =
      "You are about to clear all hisaab history. Your monthly total and customer's hisaab history will be reseted to zero.";
  String warningForforceSend =
      "You are about to send receipts to all the customers. This is not the receipt day.";
  String litrePrice = '0';

  saveLitreSettings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("Slitreprice", litrePrice);
  }

  @override
  void initState() { 
    super.initState();
    getSavedLitrePrice();
  }

  getSavedLitrePrice()  async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      litrePrice = pref.getString("Slitreprice");
    } catch (error) {
      litrePrice = "0";
    }
    setState(() {
    });
  }

  _showAdduserBottomSheet(context, sheetheight, title, prefilled) {
    showModalBottomSheet(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: MediaQuery.of(context).size.height * sheetheight,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0)),
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 28),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextFormField(
                          onChanged: (value) {
                            litrePrice = value;
                          },
                          autofocus: true,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          cursorColor: Theme.of(context).accentColor,
                          cursorRadius: Radius.circular(10),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: prefilled,
                          )),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Material(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          focusColor: Colors.white,
                          splashColor: Colors.white,
                          onTap: () {
                            saveLitreSettings();
                            Navigator.of(context).pop();
                            FServices().showToastMessage(context, "Litre Price saved!");
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          );
        },
        isScrollControlled: true);
  }

  customDialog(warning) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.white,
              insetAnimationCurve: Curves.bounceOut,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)), //this right here
              child: Container(
                height: height * 0.31,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Text(
                        "Are you sure?",
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 25),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Text(warning,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor)),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            elevation: 5,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              focusColor: Theme.of(context).primaryColor,
                              splashColor: Theme.of(context).accentColor,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text(
                                    'Cancel',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.1,
                          ),
                          Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            elevation: 5,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              focusColor: Theme.of(context).primaryColor,
                              splashColor: Theme.of(context).accentColor,
                              onTap: () {},
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text(
                                    "I'm sure",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }


  @override
  Widget build(BuildContext context) {
    
    Widget settingContent = Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: width * 0.07, right: width * 0.07, top: height * 0.07),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Price/Litre',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: width * 0.037),
                ),
                Material(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 2.5,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            litrePrice == null ? "0" : 'Rs. ${litrePrice}',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: width * 0.05),
                          ),
                          IconButton(
                              splashRadius: 25,
                              icon: Icon(
                                Icons.mode_edit,
                                color: Theme.of(context).accentColor,
                              ),
                              color: Theme.of(context).accentColor,
                              iconSize: width * 0.06,
                              onPressed: () {
                                _showAdduserBottomSheet(
                                    context, 0.23, "Price/Litre", litrePrice);
                              }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: width * 0.07, right: width * 0.07, top: height * 0.05),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Receipt Day',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: width * 0.037),
                ),
                Material(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 2.5,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1st of every month',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: width * 0.05),
                          ),
                          IconButton(
                              splashRadius: 25,
                              icon: Icon(
                                Icons.mode_edit,
                                color: Theme.of(context).accentColor,
                              ),
                              color: Theme.of(context).accentColor,
                              iconSize: width * 0.06,
                              onPressed: () {
                                _showAdduserBottomSheet(
                                    context, 0.23, "Receipt Day", "1");
                              }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: width * 0.07, right: width * 0.07, top: height * 0.06),
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(30.0),
              focusColor: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).accentColor,
              onTap: () {
                customDialog(warningForclearHisaab);
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    'Clear all hisaab',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: width * 0.05),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: width * 0.07, right: width * 0.07, top: height * 0.06),
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(30.0),
              focusColor: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).accentColor,
              onTap: () {
                customDialog(warningForforceSend);
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    'Force send receipt',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: width * 0.05),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    // Main BackGround
    Container background_container = Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
    );

    Widget listView_container = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: height * 0.10,
        ),
        Expanded(
          child: Container(
            width: width,
            child: settingContent,
            decoration: BoxDecoration(
                color: Color.fromRGBO(230, 232, 232, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
          ),
        )
      ],
    );

    Widget texts = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).cardColor,
                    ),
                    color: Theme.of(context).cardColor,
                    iconSize: width * 0.06,
                    onPressed: () {
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));
                    }),
                SizedBox(
                  width: width * 0.23,
                ),
                Text('Settings',
                    style: TextStyle(
                      color: barTextColor,
                      fontSize: width * 0.07,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.0, 1.5),
                          blurRadius: 1.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    )),
                SizedBox(
                  width: width * 0.23,
                ),
                IconButton(
                    icon: Icon(
                      Icons.info,
                      color: Theme.of(context).cardColor,
                    ),
                    color: Theme.of(context).cardColor,
                    iconSize: width * 0.06,
                    onPressed: () {})
              ],
            ),
          ),
        ),
      ],
    );

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).primaryColor,
            body: Stack(
              children: <Widget>[
                background_container,
                listView_container,
                texts
              ],
            )));
  }
}
