import 'package:fazle_rabbi/adddailyHisaabList.dart';
import 'package:fazle_rabbi/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fazle_rabbi/profile_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fazle_rabbi/SaveCustomerData.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fazle_rabbi/adddailyHisaabList.dart';


void main() => (runApp(MyApp()));

double height = window.physicalSize.height / window.devicePixelRatio;
double width = window.physicalSize.width / window.devicePixelRatio;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fazle Rabbi',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color.fromRGBO(5, 153, 123, 1),
        accentColor: Color.fromRGBO(2, 105, 84, 1),
        cardColor: Color.fromRGBO(230, 232, 232, 1),
        canvasColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
            bodyText1: TextStyle(
                fontFamily: "MavenPro", color: Theme.of(context).accentColor),
            bodyText2: TextStyle(
                fontFamily: "MavenPro", color: Color.fromRGBO(0, 0, 0, 0.7))),
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Color green_accent_color = Color.fromRGBO(221, 235, 231, 1);
  Color barTextColor = Color.fromRGBO(230, 232, 232, 1);
  String customerName;
  String customerNumber;
  String customerAddress = 'No address';
  String totalCustomers;
  String totalEarnings;
  List<Widget> listofCustomers = [];

  @override
  void initState() {
    super.initState();
    initializeCustomerList();
  }

  initializeCustomerList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List allKeys = pref.getKeys().toList();
    int count = 0;
    double totalEarning = 0;

    allKeys.forEach((element) {
      if ( !element.contains("HI") && !element.contains("S")) {
        Map customerData = jsonDecode(pref.getString(element));
        totalEarning += double.parse(customerData["total"]);

        listofCustomers.add(customer(
            count,
            customerData['key'],
            customerData['name'],
            customerData['number'],
            customerData['address'],
            customerData['total']));
        count += 1;
      }
    });

    totalCustomers =
        listofCustomers.length == 0 ? '0' : listofCustomers.length.toString();
    totalEarnings = totalEarning.toString();

    setState(() {});
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

  _addUserDetailSheet(
      @required bool newUser, @required bool editUser, index, sharedPrefKey) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: width,
              height: height * 0.62,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.09),
                child: Column(
                  children: [
                    Text(
                      "Customer's name*",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: width * 0.04),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Material(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        elevation: 5,
                        child: TextFormField(
                            onChanged: (text) {
                              customerName = text;
                            },
                            textCapitalization: TextCapitalization.words,
                            textAlign: TextAlign.center,
                            cursorColor: Theme.of(context).accentColor,
                            cursorRadius: Radius.circular(10),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.2),
                              ),
                              hintText: editUser == false
                                  ? "e.g Lorem Posum"
                                  : customerName,
                            )),
                      ),
                    ),
                    Text(
                      "Customer's number*",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: width * 0.04),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Material(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        elevation: 5,
                        child: TextFormField(
                            onChanged: (text) {
                              customerNumber = text;
                            },
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.center,
                            cursorColor: Theme.of(context).accentColor,
                            cursorRadius: Radius.circular(10),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.2),
                              ),
                              hintText: editUser == false
                                  ? "e.g 03123456789"
                                  : customerNumber,
                            )),
                      ),
                    ),
                    Text(
                      "Customer's address*",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: width * 0.04),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Material(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        elevation: 5,
                        child: TextFormField(
                            onChanged: (text) {
                              if (text != '' || text != ' ') {
                                customerAddress = text;
                              }
                            },
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.streetAddress,
                            textAlign: TextAlign.center,
                            cursorColor: Theme.of(context).accentColor,
                            cursorRadius: Radius.circular(10),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.2),
                              ),
                              hintText: editUser == false
                                  ? "e.g Street 21 Block 20 Karachi, PK"
                                  : customerAddress,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.022,
                    ),
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
                            if (customerName != null &&
                                customerNumber != null) {
                              if (editUser == false) {
                                addCustomer();
                                Navigator.pop(context);
                                return Fluttertoast.showToast(
                                    msg: 'customer added',
                                    fontSize: 15,
                                    textColor: Theme.of(context).accentColor,
                                    backgroundColor: green_accent_color);
                              } else if (editUser == true) {
                                editCustomerSave(index, sharedPrefKey);
                                Navigator.pop(context);
                                return Fluttertoast.showToast(
                                    msg: 'customer edited',
                                    fontSize: 15,
                                    textColor: Theme.of(context).accentColor,
                                    backgroundColor: green_accent_color);
                              }
                            } else {
                              return Fluttertoast.showToast(
                                  msg: 'Please fill all the required fields',
                                  fontSize: 15,
                                  textColor: Theme.of(context).accentColor,
                                  backgroundColor: green_accent_color);
                            }
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                editUser == false
                                    ? 'Add Customer'
                                    : 'Edit Customer',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 23),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(60),
              onTap: () {
                print('Change image');
              },
              child: Material(
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0),
                ),
                elevation: 10,
                child: CircleAvatar(
                  backgroundColor: green_accent_color,
                  backgroundImage: AssetImage("assets/addimage.png"),
                  radius: 60,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  customer(@required index, @required sharedPrefKey, @required name,
      @required number, @required address, @required total) {
    return Padding(
      padding: EdgeInsets.all(width * 0.02),
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5,
        // borderRadius: BorderRadius.circular(30.0),
        child: InkWell(
            borderRadius: BorderRadius.circular(30.0),
            focusColor: Theme.of(context).primaryColor,
            splashColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(
                            sharedPrefKey: sharedPrefKey,
                            index: index,
                          )));
            },
            child: Padding(
              padding: EdgeInsets.all(width * 0.025),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Material(
                        elevation: 5,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: green_accent_color,
                          backgroundImage: AssetImage("assets/addimage.png"),
                          radius: 48,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: width * 0.01),
                        child: PopupMenuButton(
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).primaryColor,
                            size: width * 0.07,
                          ),
                          itemBuilder: (context) {
                            return <PopupMenuItem>[
                              new PopupMenuItem(
                                  child: Center(child: Text('Add Hisab'))),
                              new PopupMenuItem(
                                  child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  editCustomer(index, sharedPrefKey);
                                },
                                child: Center(
                                  child: Text('Edit',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Theme.of(context).accentColor)),
                                ),
                              )),
                              new PopupMenuItem(
                                  child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  deleteCustomer(index, sharedPrefKey);
                                },
                                child: Center(
                                  child: Text('Delete',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Theme.of(context).accentColor)),
                                ),
                              ))
                            ];
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: height * 0.015),
                  Text(
                    name,
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 20),
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'total',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: width * 0.02),
                        child: Text(
                          total,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  main_container() {
    return Container(
      height: height,
      width: width,
      color: Theme.of(context).primaryColor,
    );
  } // Main BackGround

  main_circle() {
    return Column(
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
            radius: 63,
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
                    enableFeedback: true,
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).cardColor,
                    ),
                    color: Theme.of(context).cardColor,
                    iconSize: width * 0.06,
                    onPressed: () {
                      _showAdduserBottomSheet(
                          context, Text('ADD USER'), Colors.white, 0.4);
                    }),
                SizedBox(
                  width: width * 0.20,
                ),
                Text('Fazle Rabbi',
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
                  width: width * 0.20,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsPage()));
                        },
                        child: Center(
                          child: Text('Settings',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor)),
                        ),
                      )),
                      new PopupMenuItem(
                          child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => super.widget));
                        },
                        child: Center(
                          child: Text('Refresh',
                              style: TextStyle(
                                  fontSize: 14,
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
                  'Earnings\n${totalEarnings}',
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
                height: height * 0.06,
                width: width * 0.25,
                child: Text(
                  'Customers\n${totalCustomers}',
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
  }

  noCustomerText() {
    return Center(
      child: Text(
        "No customers added",
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontSize: height * 0.03),
      ),
    );
  }

  listView_container() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: height * 0.20,
        ),
        Expanded(
          child: Container(
            width: width,
            child: listofCustomers.length == 0
                ? noCustomerText()
                : customers_grid(),
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

  customers_grid() {
    return GridView(
      children: listofCustomers,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: height * 0.0011),
      padding: EdgeInsets.only(
          left: width * 0.035,
          right: width * 0.035,
          top: height * 0.07,
          bottom: height * 0.02),
    );
  }

  addCustomersFloatingButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.045),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0)),
                  elevation: 5,
                  child: Icon(
                    Icons.group_add,
                    size: height * 0.04,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    _showAdduserBottomSheet(
                        context,
                        _addUserDetailSheet(true, false, null, null),
                        Colors.transparent,
                        0.7);
                    // addCustomer();
                  }),
                  SizedBox(width: width*0.05,),
                  FloatingActionButton(
                    heroTag: null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0)),
                  elevation: 5,
                  child: Icon(
                    Icons.list,
                    size: height * 0.04,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuickHisaabList()));
                    // addCustomer();
                  }),

            ],
          ),
        ),
      ],
    );
  }

  addCustomer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String key = await SaveCustomer().generateSharedKey();
    SaveCustomer().saveDatainSharedPreference(
        key, customerName, customerNumber, customerAddress, "0");

    listofCustomers = listofCustomers +
        (listofCustomers.length == 0
            ? [
                customer(
                    0, key, customerName, customerNumber, customerAddress, '0')
              ]
            : [
                customer(listofCustomers.length, key, customerName,
                    customerNumber, customerAddress, '0')
              ]);

    setState(() {
      totalCustomers =
          listofCustomers.length == 0 ? '0' : listofCustomers.length.toString();
    });
    customerName = null;
    customerNumber = null;
    customerAddress = 'No address';
  }

// Figure out some other way to delete customer! index is creating problems.
  deleteCustomer(index, sharedIndex) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(sharedIndex);
    pref.remove("HI"+sharedIndex);
    print(index.toString() + "  " + sharedIndex);
    List<Widget> tempList = [];

    if (listofCustomers.length == 1) {
      listofCustomers = [];
    } else {
      listofCustomers.forEach((element) {
        if (listofCustomers.indexOf(element) != index) {
          tempList.add(element);
        }
      });

      listofCustomers = tempList.sublist(0);
    }
    initializeCustomerList();
    setState(() {
      totalCustomers =
          listofCustomers.length == 0 ? '0' : listofCustomers.length.toString();
    });
  }

  editCustomer(index, sharedPrefKey) async {
    Navigator.pop(context);

    SharedPreferences pref = await SharedPreferences.getInstance();
    Map customerTobeEdited = jsonDecode(pref.getString(sharedPrefKey));

    customerName = customerTobeEdited['name'];
    customerNumber = customerTobeEdited['number'];
    customerAddress = customerTobeEdited['address'];

    setState(() {});

    _showAdduserBottomSheet(
        context,
        _addUserDetailSheet(false, true, index, sharedPrefKey),
        Colors.transparent,
        0.7);
  }

  editCustomerSave(index, sharedPrefKey) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map customerData = jsonDecode(pref.getString(sharedPrefKey));
    String total = customerData['total'];
    String lastEdit = customerData['last_edit'];

    pref.remove(sharedPrefKey);

    SaveCustomer().saveDatainSharedPreference(
        sharedPrefKey, customerName, customerNumber, customerAddress, total);

    List<Widget> tempList = [];

    tempList = [
      customer(index, sharedPrefKey, customerName, customerNumber,
          customerAddress, total)
    ];

    if (index != 0 && index != listofCustomers.length - 1) {
      listofCustomers = listofCustomers.sublist(0, index) +
          tempList +
          listofCustomers.sublist(index + 1);
    } else if (index == 0) {
      listofCustomers = tempList + listofCustomers.sublist(1);
    } else if (index == listofCustomers.length - 1) {
      listofCustomers = listofCustomers.sublist(0, index - 1) + tempList;
    }

    setState(() {});
    customerName = null;
    customerNumber = null;
    customerAddress = 'No address';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Theme.of(context).primaryColor));

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).primaryColor,
            body: Stack(
              children: <Widget>[
                main_container(),
                listView_container(),
                main_circle(),
                texts(),
                addCustomersFloatingButton()
              ],
            )));
  }
}
