import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fazle_rabbi/main.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fazle_rabbi/hisaabList.dart';
import 'package:fazle_rabbi/services.dart';
import 'package:intl/intl.dart';
import 'package:fazle_rabbi/SaveCustomerData.dart';
import 'package:fazle_rabbi/sendHisaab.dart';

class QuickHisaabList extends StatefulWidget {
  QuickHisaabList({Key key}) : super(key: key);

  @override
  _QuickHisaabListState createState() => _QuickHisaabListState();
}

class _QuickHisaabListState extends State<QuickHisaabList> {
  Color green_accent_color = Color.fromRGBO(221, 235, 231, 1);
  Color barTextColor = Color.fromRGBO(230, 232, 232, 1);
  double height = window.physicalSize.height / window.devicePixelRatio;
  double width = window.physicalSize.width / window.devicePixelRatio;
  List<Widget> quickAddCustomersList = [];

  @override
  void initState() {
    super.initState();
    initializeCustomerList();
  }

  initializeCustomerList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List allKeys = pref.getKeys().toList();

    allKeys.forEach((element) {
      if (!element.contains("HI") && !element.contains("S")) {
        Map customerData = jsonDecode(pref.getString(element));
        quickAddCustomersList
            .add(customerContainer(customerData["name"], element));
      }
    });

    setState(() {});
  }

  showCustomDatePicker(context) async {
    List<DateTime> newDateTime = await DateRangePicker.showDatePicker(
        context: context,
        initialFirstDate: DateTime.now(),
        initialLastDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2021));

    if (newDateTime != null && newDateTime.length == 2) {
      String d1 = DateFormat('EEE, MMM d, ' 'yy').format(newDateTime[0]);
      String d2 = DateFormat('EEE, MMM d, ' 'yy').format(newDateTime[1]);
      if (d1 == d2) {
        return [newDateTime[0]];
      }
    }

    return newDateTime;
  }

  customerContainer(@required name, @required sharedPrefKey) {
    Color dateSelectButtonColor = Color.fromRGBO(230, 232, 232, 1);
    Color dateSelectButtonTextColor = Color.fromRGBO(2, 105, 84, 1);
    String dateSelectButtonText = "Select date";
    String priceLitre;
    List customDates;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10.0),
        elevation: 2.5,
        child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: width * 0.05),
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      elevation: 2,
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: width * 0.26,
                        height: height * 0.058,
                        child: TextFormField(
                            onChanged: (text) {
                              priceLitre = text;
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: Theme.of(context).accentColor,
                            cursorRadius: Radius.circular(10),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Price/Litre",
                                hintStyle:
                                    TextStyle(fontSize: 15, height: 3.1))),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Material(
                      color: dateSelectButtonColor,
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        focusColor: Theme.of(context).primaryColor,
                        splashColor: Theme.of(context).primaryColor,
                        onTap: () async {
                          print("working");
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          print("working2");

                          try {
                            List hisaabData = jsonDecode(
                                pref.getString("HI" + sharedPrefKey));
                            customDates = hisaabData;
                          } catch (error) {
                            List hisaabData = null;
                            customDates = hisaabData;
                          }

                          if (customDates == null && priceLitre != null) {
                            List customDatesDateTime =
                                await showCustomDatePicker(context);
                            if (customDatesDateTime != null) {
                              customDates = await HisaabList(priceLitre)
                                  .createMap(customDatesDateTime);
                            } else {
                              FServices().showToastMessage(
                                  context, "No date selected");
                            }
                            customDates = await HisaabList(priceLitre)
                                .createMap(customDatesDateTime);
                          } else if (customDates != null &&
                              priceLitre != null) {
                            List newDates = await showCustomDatePicker(context);
                            if (newDates != null) {
                              List newDatesMap = await HisaabList(priceLitre)
                                .createMap(newDates);
                            List currentDates =
                                customDates.map((e) => e['date']).toList();
                            newDatesMap.forEach((element) {
                              if (currentDates.contains(element['date'])) {
                                int indexOfreplacement =
                                    currentDates.indexOf(element['date']);
                                customDates[indexOfreplacement] = element;
                              } else {
                                customDates = customDates + [element];
                              }
                            });
                            FServices().showToastMessage(context, "Selected!");
                            } else {
                              FServices().showToastMessage(
                                  context, "No date selected");
                            }
                            
                          }
                          
                        },
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              dateSelectButtonText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: dateSelectButtonTextColor,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                        heroTag: null,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        elevation: 3,
                        child: Icon(
                          Icons.add_box,
                          size: height * 0.035,
                          color: Theme.of(context).primaryColor,
                        ),
                        backgroundColor: Theme.of(context).cardColor,
                        onPressed: () {
                          if (customDates != null) {
                            String customerTotal = HisaabList(priceLitre)
                                .getCustomerTotal(customDates, sharedPrefKey)
                                .toString();
                            SaveCustomer().updateCustomerTotalInSharedPref(
                                sharedPrefKey, customerTotal);
                            HisaabList(priceLitre).saveHisaabtoSharedPref(
                                customDates, sharedPrefKey);
                            FServices()
                                .showToastMessage(context, "Hisaab Updated!");
                            setState(() {});
                          } else {
                            FServices().showToastMessage(
                                context, "Select a valid date");
                          }
                        })
                  ],
                )
              ],
            )),
      ),
    );
  }

  detail_container_scrollable() {
    return ListView(
      // controller: scroll_controller,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              left: width * 0.05, right: width * 0.05, top: height * 0.04),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Customers',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: height * 0.025),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: quickAddCustomersList == null
                      ? [Text("No customers")]
                      : quickAddCustomersList,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  main_container() {
    return Container(
      height: height,
      width: width,
      color: Theme.of(context).primaryColor,
    );
  }

  listView_container() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: height * 0.10,
        ),
        Expanded(
          child: Container(
            width: width,
            child: detail_container_scrollable(),
            decoration: BoxDecoration(
                color: Color.fromRGBO(230, 232, 232, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
          ),
        )
      ],
    );
  }

  texts() {
    return Column(
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
                Text('Quick Add',
                    style: TextStyle(
                      color: barTextColor,
                      fontSize: width * 0.06,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.0, 1.5),
                          blurRadius: 1.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    )),
                SizedBox(
                  width: width * 0.30,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme.of(context).primaryColor,
            body: Stack(
              children: <Widget>[
                main_container(),
                listView_container(),
                texts()
              ],
            )));
  }
}
