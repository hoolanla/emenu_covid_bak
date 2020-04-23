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
import 'package:condition/condition.dart';
import 'package:emenu_covid/screens/admin/WebviewMenu.dart';


Future<ResultOrderHeaderToday> resultOrderHeaderToday;
List<ResultOrderHeaderToday> _searchResult = [];
List<ResultOrderHeaderToday> _orderDetails = [];
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
  TextEditingController editingController = TextEditingController();

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

      print(globals.restaurantID + "  " + globals.userID);
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
                              status: menu.orderHeaderTodayList[idx].status,
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
                                  String tmp = menu
                                      .orderHeaderTodayList[idx].tel
                                      .toString()
                                      .substring(1);
                                  if (tmp.length > 0) {
                                    Tlaunch.launch("tel:+66" + tmp);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: _buildText(
                          status:
                              menu.orderHeaderTodayList[idx].status.toString()),
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


  Widget _buildSearch(){
   return Padding(
      padding: const EdgeInsets.all(8.0),

      child: TextField(
        onChanged: (value) {
setState(() {
  _searchResult.clear();
  if (value.isEmpty) {
    setState(() {});
    return;
  }

  _orderDetails.forEach((userDetail) {

  });


});
        },
        controller: editingController,
        decoration: InputDecoration(

            labelText: "Search",
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(

                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }


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
                          builder: (context) => OrderHeaderToday()),
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
            new IconButton(
                icon: new Icon(Icons.home),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WebviewMenu()),
                  );
                }),
            //   new IconButton(icon: new Text('SAVE'), onPressed: null),



            new IconButton(
                icon: new Icon(Icons.add_shopping_cart),
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
