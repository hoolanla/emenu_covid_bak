
import 'package:emenu_covid/models/setMenu.dart';
import 'package:emenu_covid/models/orderHeaderToday.dart';
import 'package:flutter/material.dart';
import 'package:emenu_covid/models/order.dart';
import 'dart:async';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/sqlite/db_helper.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/models/bill.dart';
import 'package:emenu_covid/screens/admin/OrderDetailToday.dart';
import 'package:emenu_covid/models/logout.dart';
import 'package:emenu_covid/services/AlertForm.dart';
import 'package:url_launcher/url_launcher.dart' as Tlaunch;
import 'package:condition/condition.dart';
import 'package:emenu_covid/screens/admin/WebviewMenu.dart';
import 'package:emenu_covid/screens/admin/QRcode.dart';


Future<setMenu> _menuList;



void main() {
  runApp(SetMenu());
}

class SetMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowData();
  }
}

class _ShowData extends State<SetMenu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    refreshMenu();
  }

  refreshMenu() {
    setState(() {

      _menuList = NetworkFoods.loadMenu();
    });
  }

  Widget _ListSectionStatus({setMenu menu}) => ListView.builder(
    itemBuilder: (context, int idx) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 1.0,
              ),
              child: Container(
                child: new ListTile(
//                  onTap: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => OrderDetailTodayPage(
//                          orderID: menu.menuList[idx].menuID,
//                          restaurantID: globals.restaurantID,
//                          status: menu.menuList[idx].menuActivate,
//                        ),
//                      ),
//                    );
//                  },
                  title: Text(

                        menu.menuList[idx].menuName.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                      color: Colors.deepOrange,
                    ),
                  ),
                  subtitle: new Column(
                    children: <Widget>[

                      new Row(
                        children: <Widget>[
                          Text(

                                menu.menuList[idx].price
                                    .toString()
                                    .toString() +
                                ' บาท',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                  trailing: _buildText(
                      status:
                      menu.menuList[idx].menuActivate.toString()),
                ),
                decoration: new BoxDecoration(
                  border: Border(
                    bottom: new BorderSide(
                      color: Colors.cyan,
                      width: 0.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
    itemCount: menu.menuList.length,
  );




  Widget _buildText({String status}) {
    if (status == "Cancel") {
      return Text(
        status,
        style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit'),
      );
    }
    return Text(
      status,
      style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kanit'),
    );
  }

  Widget HeaderColumn() {
    return new Container(
      height: 30,
      child: new ListTile(
        onTap: null,
        title: Row(children: <Widget>[
          new Expanded(
              child: new Text(
                "รายการ",
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ]),
        trailing: Text(
          'สถานะ ',
          style: TextStyle(
            fontFamily: 'Kanit',
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _noOrder() {
    return new Card();
  }

  headerListOrder() {
    return Text(
      'ORDER',
      style: TextStyle(
          color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }

  headerStatusOrder() {
    return Text(
      'STATUS ORDER',
      style: TextStyle(
          color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }

  listStatusOrder() {
    return Expanded(
      child: FutureBuilder<setMenu>(
          future: _menuList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (snapshot.data.ResultOk == "false") {
                  return _noOrder();
                } else {
                  return new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Expanded(
                        child: _ListSectionStatus(menu: snapshot.data),
                      ),
                    ],
                  );
                }
              } else {
                return Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          child: CircularProgressIndicator(),
                          height: 10.0,
                          width: 10.0,
                        )
                      ],
                    ),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        height: 10.0,
                        width: 10.0,
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: 'Kanit',
          ),
        ),
        backgroundColor: Colors.cyan,
        title: new Text(
          'ออเดอร์วันนี้',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 20.0,
            fontFamily: 'Kanit',
          ),
        ),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            //  _buildSearch(),
            HeaderColumn(),
            listStatusOrder(),
            Row(children: <Widget>[
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: new RaisedButton(
                  color: Colors.pinkAccent,
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetMenu()),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 4,
              ),
            ])
          ],
        ),
      ),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.cyan,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
//            new IconButton(
//                icon: new Icon(Icons.home),
//                color: Colors.white,
//                onPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => WebviewMenu()),
//                  );
//                }),




            new IconButton(
                icon: new Icon(Icons.store_mall_directory),
                color: Colors.white,
                onPressed: () {
                  if (globals.restaurantID != null) {
                    if (globals.restaurantID != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WebviewMenu()),
                      );
                    } else {}
                  } else {}
                }),


            new IconButton(
                icon: new Icon(Icons.center_focus_weak),
                color: Colors.white,
                onPressed: () {
                  if (globals.restaurantID != null) {
                    if (globals.restaurantID != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QRcode()),
                      );
                    } else {}
                  } else {}
                }),



          ],
        ),
      ),
    );
  }
}

class DataFeed {
  RetStatusInsertOrder feed;

  DataFeed({this.feed});
}

class DataFeedBill {
  RetBill feed;

  DataFeedBill({this.feed});
}

class DataFeedJson {
  strJsonOrder feed;

  DataFeedJson({this.feed});
}

class DataFeedLogout {
  LogoutTable feed;

  DataFeedLogout({this.feed});
}
