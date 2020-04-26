import 'package:emenu_covid/models/orderHeader.dart';
import 'package:flutter/material.dart';
import 'package:emenu_covid/models/order.dart';
import 'dart:async';
import 'package:emenu_covid/screens/home/FirstPage.dart';
import 'package:emenu_covid/screens/home/DetailCommendPage.dart';
import 'package:emenu_covid/screens/home/MyOrder.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/sqlite/db_helper.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/models/bill.dart';
import 'package:emenu_covid/screens/home/OrderDetail.dart';
import 'package:emenu_covid/models/logout.dart';
import 'package:emenu_covid/services/AlertForm.dart';


Future<ResultOrderHeader> resultOrderHeader;
Future<double> _totalsCheckbill;

String jsonBody;

Future<RetStatusInsertOrder> retInsert;
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
  runApp(OrderHeader());
}

class OrderHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowData();
  }
}

class _ShowData extends State<OrderHeader> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String strBody =
      '{"restaurantID":"","userID":"${globals.userID}","status":""}';
  var dbHelper;
  bool isUpdating;
  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    refreshOrderHeader();
    refreshTotalHeader();
  }

  showSnak() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("ไม่สามารถสั่งได้ กำลงัเคลียร์โต๊ะ"),
      backgroundColor: Colors.deepOrange,
      duration: Duration(seconds: 2),
    ));
  }

  refreshOrderHeader() {
    setState(() {
      resultOrderHeader = NetworkFoods.loadOrderHeader(strBody);
    });
  }

  refreshTotalHeader() {
    setState(() {
      _totalsCheckbill = NetworkFoods.loadTotalOrderHeader(strBody);

    });
  }
  void _showAlertDialog2({String strError}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(strError),
            content: Text(""),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderHeader()),
                  );
                },
                child: Text("OK"),
              )
            ],
          );
        });
  }

  Widget _ListSectionStatus({ResultOrderHeader menu}) => ListView.builder(
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
                            builder: (context) => OrderDetail(
                              orderID: menu.orderHeaderList[idx].orderID,
                              restaurantID: menu.restuarantID,

                            ),
                          ),
                        );
                      },
                      title: Text(
                        menu.orderHeaderList[idx].createDate.toString() +
                            '  ' +
                            menu.orderHeaderList[idx].orderID.toString(),
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
                              Text(   menu.orderHeaderList[idx].restaurant_name.toString(),

                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Text(   menu.orderHeaderList[idx].qty.toString() +
                                'x     รวมราคา: ' +
                                    menu.orderHeaderList[idx].totalPrice
                                        .toString() + ' บาท',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(
                        menu.orderHeaderList[idx].status.toString(),
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          color: Colors.green,
                          fontWeight: FontWeight.bold
                        ),
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
        itemCount: menu.orderHeaderList.length,
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
    return new Card(
        );
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
      child: FutureBuilder<ResultOrderHeader>(
          future: resultOrderHeader,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (snapshot.data.ResultOk == "false") {
                  return _noOrder();
                }
                else
                  {
                  return new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Expanded(
                        child: _ListSectionStatus(menu: snapshot.data),
                      ),
                    ],
                  );
                }
              }
              else
                {
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
          'รายการอาหารที่สั่ง',
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
              SizedBox(width: 4,),
              Expanded(
                child: new RaisedButton(
                  color: Colors.pinkAccent,
                  child: FutureBuilder(
                      future: _totalsCheckbill,
                      builder: (context, snapshot) {
                        return Text(
                          'รวมราคา  ${snapshot.data.toString().replaceAll('.0', '')} บาท',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Kanit',
                          ),
                        );
                      }),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderHeader()),
                    );
                  },
                ),
              ),
              SizedBox(width: 4,),
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
            new IconButton(
                icon: new Icon(Icons.home),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FirstPage()),
                  );
                }),
            new IconButton(
                icon: new Icon(Icons.restaurant),
                color: Colors.white,
                onPressed: () {
                  if (globals.restaurantID != null) {
                    if (globals.restaurantID != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailCommendPage(
                              restaurantID: globals.restaurantID,
                              tel: globals.restaurantTel,
                              open_time: globals.openTimeRest,
                              close_time: globals.closeTimeRest,
                            )),
                      );
                    } else {}
                  } else {}
                }),

            new IconButton(
                icon: new Icon(Icons.add_shopping_cart),
                color: Colors.white,
                onPressed: () {
                  if (globals.restaurantID != null) {
                    if (globals.restaurantID != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyOrder()),
                      );
                    } else {}
                  } else {}
                }),
//            new IconButton(
//                icon: new Icon(Icons.list),
//                color: Colors.white,
//                onPressed: () {
//                  if (globals.restaurantID != null) {
//                    if (globals.restaurantID != '') {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => OrderHeader()),
//                      );
//                    } else {}
//                  } else {}
//                }),
            new IconButton(
                icon: new Icon(Icons.exit_to_app),
                color: Colors.white,
                onPressed: () {
                  AlertService tmp = new AlertService(title: 'Are you sure ?',desc: 'คุณต้องการออกจาก Application ใช่ไหม');
                  tmp.showAlertExit(context);
                //  showAlert(context);
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
