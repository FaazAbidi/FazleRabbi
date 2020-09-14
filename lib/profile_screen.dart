import 'dart:convert';
import 'dart:developer';
import 'package:fazle_rabbi/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fazle_rabbi/services.dart';
import 'package:fazle_rabbi/SaveCustomerData.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:fazle_rabbi/hisaabList.dart';
import 'package:fazle_rabbi/sendHisaab.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:ui';
import 'dart:math';

class Profile extends StatefulWidget {
  String sharedPrefKey;
  int index;
  Profile({Key key, this.sharedPrefKey, this.index}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // String customerName;
  // String customerNumber;
  // String customerAddress;
  // _ProfileState(this.customerName, this.customerNumber, this.customerAddress);

  final scroll_controller = ScrollController();
  Color green_accent_color = Color.fromRGBO(221, 235, 231, 1);
  Color barTextColor = Color.fromRGBO(230, 232, 232, 1);
  double height = window.physicalSize.height / window.devicePixelRatio;
  double width = window.physicalSize.width / window.devicePixelRatio;
  double scroll_opacity = 1;
  String customerName;
  String customerNumber;
  String customerAddress;
  String customerTotal;
  String customerLastEdit;
  List<DataRow> dataRowList = [];
  List customDates;
  String litre;
  String displayDateStr = 'Pick a date';

  @override
  void initState() {
    super.initState();
    decodeCustomerDatafromSharedPref(widget.sharedPrefKey);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onScroll();
    });
  }

  @override
  void dispose() {
    super.dispose();
    scroll_controller.dispose();
  }

  decodeCustomerDatafromSharedPref(String sharedPrefKey) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map customerData = jsonDecode(pref.getString(sharedPrefKey));
    customerName = customerData['name'];
    customerNumber = customerData['number'];
    customerAddress = customerData['address'];
    customerTotal = customerData['total'];
    customerLastEdit = customerData['last_edit'];

    try {
      List hisaabData = jsonDecode(pref.getString("HI" + sharedPrefKey));
      customDates = hisaabData;
      dataRowList = HisaabList(litre).hissabDateRow(customDates);
    } catch (error) {
      print("no hisaab");
    }

    setState(() {});
  }

  onScroll() async {
    double offSets = scroll_controller.offset;

    if (offSets <=
        (window.physicalSize.height / window.devicePixelRatio) * 0.24) {
      scroll_opacity = 1 - (offSets * 0.01) >= 0 ? 1 - (offSets * 0.01) : 0;
      // scroll_opacity = Tween(1.0, 0.0);
      setState(() {});
    }
  }

  deleteAllhisaab() async {
    dataRowList = [];
    customDates = [];

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("HI" + widget.sharedPrefKey);
    SaveCustomer().updateCustomerTotalInSharedPref(widget.sharedPrefKey, "0");

    setState(() {});
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
                            onTap: () {
                              deleteAllhisaab();
                              Navigator.of(context).pop();
                              FServices()
                                  .showToastMessage(context, "hisaab cleared!");
                            },
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

  _showAdduserBottomSheet(
      context, child, Color color, double heightInDecimals) {
    showModalBottomSheet(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height:
                  MediaQuery.of(context).size.height * heightInDecimals, // 0.4
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(30.0)),
              child: child,
            ),
          );
        },
        isScrollControlled: true);
  }

  addHisaab() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Padding(
      padding: EdgeInsets.only(top: height * 0.04),
      child: Column(
        children: [
          Text(
            "Litres*",
            style: TextStyle(
                color: Theme.of(context).accentColor, fontSize: width * 0.04),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Material(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              elevation: 5,
              child: TextFormField(
                  focusNode: currentFocus,
                  onChanged: (text) {
                    litre = text;
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  cursorColor: Theme.of(context).accentColor,
                  cursorRadius: Radius.circular(10),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1.2),
                    ),
                    hintText: '... litres?',
                  )),
            ),
          ),
          Text(
            "Date*",
            style: TextStyle(
                color: Theme.of(context).accentColor, fontSize: width * 0.04),
          ),
          datePickerInput(context, currentFocus),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Material(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30.0),
              elevation: 5,
              child: InkWell(
                borderRadius: BorderRadius.circular(30.0),
                focusColor: Colors.white,
                splashColor: Colors.white,
                onTap: () {
                  if (customDates != null) {
                    dataRowList = HisaabList(litre).hissabDateRow(customDates);
                    customerTotal = HisaabList(litre)
                        .getCustomerTotal(customDates, widget.sharedPrefKey)
                        .toString();
                    SaveCustomer().updateCustomerTotalInSharedPref(
                        widget.sharedPrefKey, customerTotal);
                    HisaabList(litre).saveHisaabtoSharedPref(
                        customDates, widget.sharedPrefKey);
                    Navigator.pop(context);
                    FServices().showToastMessage(context, "Hisaab Updated!");
                    setState(() {});
                  } else {
                    FServices()
                        .showToastMessage(context, "Select a valid date");
                  }
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Add Hisaab',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).cardColor, fontSize: 23),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  datePickerInput(context, currentFocus) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.0),
        elevation: 5,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          focusColor: Theme.of(context).accentColor,
          splashColor: Theme.of(context).accentColor,
          onTap: () async {
            currentFocus.unfocus();

            if (customDates == null) {
              List customDatesDateTime = await showCustomDatePicker(context);
              print(customDatesDateTime);
              if (customDatesDateTime != null) {
                customDates =
                  await HisaabList(litre).createMap(customDatesDateTime);
              } else {
                FServices().showToastMessage(context, "No date selected");
              }
              
            } else {
              List newDates = await showCustomDatePicker(context);
              
              if (newDates != null) {
                List newDatesMap = await HisaabList(litre).createMap(newDates);
              List currentDates = customDates.map((e) => e['date']).toList();
              newDatesMap.forEach((element) {
                if (currentDates.contains(element['date'])) {
                  int indexOfreplacement =
                      currentDates.indexOf(element['date']);
                  customDates[indexOfreplacement] = element;
                } else {
                  customDates = customDates + [element];
                }
              });
              FServices().showToastMessage(context, "Date is selected");
              } else {
                FServices().showToastMessage(context, "No date selected");
              }
              
            }
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                displayDateStr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showCustomDatePicker(context) async {
    List<DateTime> newDateTime = await DateRangePicker.showDatePicker(
        context: context,
        initialFirstDate: DateTime.now(),
        initialLastDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2021));

    print(newDateTime);
    if (newDateTime != null && newDateTime.length == 2) {
      String d1 = DateFormat('EEE, MMM d, ' 'yy').format(newDateTime[0]);
      String d2 = DateFormat('EEE, MMM d, ' 'yy').format(newDateTime[1]);
      if (d1 == d2) {
        return [newDateTime[0]];
      }
    }
    print (newDateTime);
    return newDateTime;
  }

  addCustomersFloatingButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0))),
                elevation: 5,
                child: Icon(
                  Icons.local_hospital,
                  size: height * 0.04,
                ),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  _showAdduserBottomSheet(
                      context, addHisaab(), Theme.of(context).cardColor, 0.4);

                  // addCustomer();
                }),
            SizedBox(
              width: width * 0.03,
            ),
            FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                elevation: 5,
                child: Icon(
                  Icons.send,
                  size: height * 0.04,
                ),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  sendHisaab(widget.sharedPrefKey).sendSMS();
                  FServices().showToastMessage(context, "Hisaab Sent!");
                  // addCustomer();
                })
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Container background_container = Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
    );

    delteUserfromProfile() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove(widget.sharedPrefKey);
      pref.remove("HI" + widget.sharedPrefKey);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Dashboard(),
        ),
        (route) => false,
      );
    }

    // CUSTOMER DETAILS AND HISAAB
    Widget detail_container_scrollable = NotificationListener<
            ScrollNotification>(
        onNotification: (scrollNotification) {
          onScroll();
        },
        child: ListView(
          controller: scroll_controller,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.07, right: width * 0.07, top: height * 0.15),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Contact Number',
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
                          child: Text(
                            customerNumber,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: width * 0.05),
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
                      'Address',
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
                          child: Text(
                            customerAddress,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: width * 0.05),
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
                      'Milk Hisaab',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: width * 0.037),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      child: Material(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 2.5,
                        child: Center(
                          child: Padding(
                              padding: EdgeInsets.all(width * 0.02),
                              child: DataTable(
                                dataRowHeight: height * 0.08,
                                horizontalMargin: height * 0.01,
                                columnSpacing: width * 0.10,
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    'Amount',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: width * 0.035),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Price',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: width * 0.035),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Date',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: width * 0.035),
                                  ))
                                ],
                                rows: dataRowList,
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));

    Widget listView_container = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: height * 0.20,
        ),
        Expanded(
          child: Container(
            width: width,
            // ADD CONTAINER CONTAINING ALL CUSTOMER INFO AND HISAB LIST (SCROLLABLE)
            child: detail_container_scrollable,
            decoration: BoxDecoration(
                color: Color.fromRGBO(230, 232, 232, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
          ),
        )
      ],
    );

    // MAIN_TEXTS
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
                          MaterialPageRoute(builder: (context) => Profile()));
                    }),
                SizedBox(
                  width: width * 0.28,
                ),
                Text('Profile',
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
                  width: width * 0.28,
                ),
                PopupMenuButton(
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).cardColor,
                    size: width * 0.07,
                  ),
                  itemBuilder: (context) {
                    return <PopupMenuItem>[
                      new PopupMenuItem(
                          child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.of(context).pop();
                          delteUserfromProfile();
                          FServices()
                              .showToastMessage(context, "customer deleted");
                        },
                        child: Center(
                          child: Text('Delete',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).accentColor)),
                        ),
                      )),
                      new PopupMenuItem(
                          child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.of(context).pop();
                          customDialog(
                              "Customer's entire hisaab will be deleted.");
                        },
                        child: Center(
                          child: Text('Clear all hisaab',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).accentColor)),
                        ),
                      )),
                    ];
                  },
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: height * 0.04,
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: height * 0.06,
                width: width * 0.25,
                child: Text(
                  'Total\n${customerTotal}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: barTextColor,
                    fontSize: width * 0.045,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 1.5),
                        blurRadius: 1.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.37,
              ),
              // wrap container with text to align them!!
              Container(
                height: height * 0.065,
                width: width * 0.3,
                child: Text(
                  'Last edit \n${customerLastEdit}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: barTextColor,
                    fontSize: width * 0.045,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 1.5),
                        blurRadius: 5.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );

    // center_circle
    Widget main_circle = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: height * 0.10,
          width: width,
        ),
        Material(
          elevation: 10,
          shape: CircleBorder(),
          child: CircleAvatar(
            backgroundColor: green_accent_color,
            backgroundImage: AssetImage("assets/addimage.png"),
            radius: 63,
          ),
        ),
        Opacity(
          opacity: scroll_opacity,
          child: Padding(
            padding: EdgeInsets.only(top: height * 0.01),
            child: Text(
              customerName != null ? customerName : null,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: width * 0.06,
                shadows: <Shadow>[
                  Shadow(
                      offset: Offset(1.0, 1),
                      blurRadius: 2,
                      color: Theme.of(context).cardColor)
                ],
              ),
            ),
          ),
        )
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
                main_circle,
                texts,
                addCustomersFloatingButton()
              ],
            )));
  }
}
