import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:fazle_rabbi/profile_screen.dart';

void main() => (runApp(MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fazle Rabbi',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(5, 153, 123, 1),
        accentColor: Color.fromRGBO(2, 105, 84, 1),
        cardColor: Color.fromRGBO(230, 232, 232, 1),
        canvasColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
            bodyText1: TextStyle(
                fontFamily: "Poppins", color: Theme.of(context).accentColor),
            bodyText2: TextStyle(
                fontFamily: "Poppins",
                color: Color.fromRGBO(230, 232, 232, 1))),
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key key}) : super(key: key);

// TODO: WORK ON VISIBILITY!!!!!!!
  _showAdduserBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0)),
            ),
          );
        },
        elevation: null);
  }

  @override
  Widget build(BuildContext context) {
    // Restricting App to always be in Portrait Mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Making App Bar Transparent
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor));

    // Main BackGround
    Container background_container = Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
    );

    // Variables
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color green_accent_color = Color.fromRGBO(221, 235, 231, 1);

    // MAIN_TEXTS
    Widget texts = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).cardColor,
                  ),
                  color: Theme.of(context).cardColor,
                  iconSize: width * 0.06,
                  padding: EdgeInsets.only(right: width * 0.21),
                  onPressed: () {
                    _showAdduserBottomSheet(context);
                  }),
              Padding(
                child: Text('Fazle Rabbi',
                    style: TextStyle(
                      fontSize: width * 0.06,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.0, 1.5),
                          blurRadius: 10.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    )),
                padding:
                    EdgeInsets.only(top: height * 0.07, right: width * 0.22),
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.04),
                child: PopupMenuButton(
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
                      new PopupMenuItem(child: Center(child: Text('Settings'))),
                      new PopupMenuItem(child: Center(child: Text('About')))
                    ];
                  },
                ),
              )
            ],
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
              Text(
                'Earnings\n12,000',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.038,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 1.5),
                      blurRadius: 10.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: width * 0.5,
              ),
              Text(
                'Customers\n25',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.038,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 1.5),
                      blurRadius: 10.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );

    // CUSTOMER GRID_CONTAINER
    Widget customer = Padding(
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
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            child: Padding(
              padding: EdgeInsets.all(width * 0.035),
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
                          backgroundImage: NetworkImage(
                              "https://icon-library.com/images/no-user-image-icon/no-user-image-icon-26.jpg"),
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
                                  child: Center(child: Text('Edit Customer'))),
                              new PopupMenuItem(
                                  child: Center(child: Text('Delete Customer')))
                            ];
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: height * 0.015),
                  Text(
                    'Sample Name',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: width * 0.04),
                  ),
                  SizedBox(height: height * 0.012),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'total',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: width * 0.029),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: width * 0.02),
                        child: Text(
                          '2,134',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: width * 0.032),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );

    // GRID VIEW WIDGET
    Widget customers_grid = GridView(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      padding: EdgeInsets.only(
          left: width * 0.035,
          right: width * 0.035,
          top: height * 0.07,
          bottom: height * 0.02),
      children: <Widget>[
        customer,
        customer,
        customer,
        customer,
        customer,
        customer,
        customer,
      ],
    );

    // Container for LISTVIEW
    Widget listView_container = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: height * 0.25,
        ),
        Expanded(
          child: Container(
            width: width,
            child: customers_grid,
            decoration: BoxDecoration(
                color: Color.fromRGBO(230, 232, 232, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
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
          height: height * 0.15,
          width: width,
        ),
        Material(
          elevation: 10,
          shape: CircleBorder(),
          child: CircleAvatar(
            backgroundColor: green_accent_color,
            backgroundImage: NetworkImage(
                "https://icon-library.com/images/no-user-image-icon/no-user-image-icon-26.jpg"),
            radius: 70,
          ),
        )
      ],
    );

    return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
            body: Stack(
      children: <Widget>[
        background_container,
        listView_container,
        main_circle,
        texts
      ],
    )));
  }
}
