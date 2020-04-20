import 'package:emenu_covid/models/orderDetailToday.dart';
import 'package:emenu_covid/models/orderHeader.dart';
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

Future<ResultOrderHeaderToday> resultOrderHeaderToday;
Future<double> _totalsCheckbill;

String jsonBody;

Future<strJsonOrder> JsonOrder;

int foodsID;
String foodsName;
double price;
String size;
String description;
String images;
int qty;
String taste;

String iTest = '';

void main() {
  runApp(OrderHeaderToday());
}

class OrderHeaderToday extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowData();
  }
}

class _ShowData extends State<OrderHeaderToday> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String strBody = '{"restaurantID":"${globals.restaurantID}","status":"0"}';
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    refreshOrderHeaderToday();
  }

  refreshOrderHeaderToday() {
    setState(() {
      resultOrderHeaderToday = NetworkFoods.loadOrderHeaderToday(strBody);
    });
  }

  Widget _ListSectionStatus({ResultOrderHeaderToday menu}) => ListView.builder(
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailTodayPage(
                              orderID: menu.orderHeaderTodayList[idx].orderID,
                              restaurantID: globals.restaurantID,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        menu.orderHeaderTodayList[idx].createDate.toString() +
                            '  ' +
                            menu.orderHeaderTodayList[idx].orderID.toString(),
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
                                'คุณ: ' +
                                    menu.orderHeaderTodayList[idx].userName
                                        .toString()
                                        .toString(),
                                style: TextStyle(
                                    fontFamily: 'Kanit',
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Text(
                                menu.orderHeaderTodayList[idx].qty.toString() +
                                    'x     รวมราคา: ' +
                                    menu.orderHeaderTodayList[idx].totalPrice
                                        .toString()
                                        .toString() +
                                    ' บาท',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                ),
                              )
                            ],
                          ),
                          new Row(

                            children: <Widget>[

                              Column(children: <Widget>[
                                Text(
                                  menu.orderHeaderTodayList[idx].tel.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                              IconButton(
                                icon: Icon(
                                  Icons.phone_in_talk,
                                  color: Colors.yellow[800],
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  String tmp = menu.orderHeaderTodayList[idx].tel.toString().substring(1);
                                  if(tmp.length > 0)
                                  {
                                    Tlaunch.launch("tel:+66" + tmp);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(
                        menu.orderHeaderTodayList[idx].status.toString(),
                        style: TextStyle(
                            fontFamily: 'Kanit',
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
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
        itemCount: menu.orderHeaderTodayList.length,
      );

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
      child: FutureBuilder<ResultOrderHeaderToday>(
          future: resultOrderHeaderToday,
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
            HeaderColumn(),
            listStatusOrder(),
            Row(children: <Widget>[
              Expanded(
                child: new RaisedButton(
                  color: Colors.pinkAccent,
                  child: Icon(Icons.refresh,color: Colors.white,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderHeaderToday()),
                    );
                  },
                ),
              ),
            ])
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