import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_tables/data_tables.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color green_accent_color = Color.fromRGBO(221, 235, 231, 1);

    Container background_container = Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
    );

    // CUSTOMER DETAILS AND HISAAB
    Widget detail_container_scrollable = ListView(
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
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '01232134124',
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
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Street 21 Block A Karachi, Pakistan',
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
                  'Hisaab History',
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
                            dataRowHeight: height*0.08,
                            horizontalMargin: height * 0.01,
                            columnSpacing: width*0.10,
                            columns: [
                              DataColumn(
                                  label: Text(
                                'Item',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: width*0.035
                                    ),
                                  
                              )),
                              DataColumn(
                                  label: Text(
                                'Amount',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: width*0.035
                                    ),
                                  
                              )),DataColumn(
                                  label: Text(
                                'Price',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: width*0.035
                                    ),
                                  
                              )),
                              DataColumn(
                                  label: Text(
                                'DateTime',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: width*0.035
                                    ),
                                  
                              ))
                            ],
                            rows: [
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Rice',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '1 KG',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '300 Rs.',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      'Mon 12 Aug 20 at 4:30 PM',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  )
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Rice',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '1 KG',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '300 Rs.',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      'Mon 12 Aug 20 at 4:30 PM',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  )
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      'Rice',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '1 KG',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '300 Rs.',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      'Mon 12 Aug 20 at 4:30 PM',
                                      style: TextStyle(
                                          fontSize: width*0.035,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).cardColor,
                  ),
                  color: Theme.of(context).cardColor,
                  iconSize: width * 0.06,
                  padding: EdgeInsets.only(right: width * 0.21),
                  onPressed: () {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => Profile()));
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
                      new PopupMenuItem(child: Center(child: Text('Delete'))),
                      new PopupMenuItem(child: Center(child: Text('Edit'))),
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
                'Total\n12,000',
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
                "Last Edit\n03 Aug 20",
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
        ),
        Padding(
          padding: EdgeInsets.only(top: height * 0.01),
          child: Text(
            'Lorem Posum',
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