
import 'package:flutter/material.dart';
import 'package:emenu_covid/models/order.dart';
import 'dart:async';
import 'package:emenu_covid/screens/home/FirstPage.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/sqlite/db_helper.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/models/bill.dart';
import 'package:emenu_covid/screens/home/DetailCommendPage.dart';
import 'package:emenu_covid/models/logout.dart';
import 'package:emenu_covid/screens/home/OrderHeader.dart';
import 'package:flutter/services.dart';
import 'package:emenu_covid/services/AlertForm.dart';

//String _restaurantID = globals.restaurantID;
//String _tableID = globals.tableID;
//String _userID = globals.userID;

Future<List<Order>> orders;
Future<StatusOrder> statusOrders;
List<Order> _order;
Future<double> _totals;
Future<double> _totalsCheckbill;
Future<String> _jsonBody;
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
  runApp(MyOrder());
}

class MyOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowData();
  }
}

class _ShowData extends State<MyOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String strBody =
      '{"restaurantID":"${globals.restaurantID}","tableID":"100","userID":"${globals.userID}"}';

  _showAlertDialog({String strError}) async {
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
                    MaterialPageRoute(builder: (context) => MyOrder()),
                  );
                },
                child: Text("OK"),
              )
            ],
          );
        });
  }

//  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    refreshList();
    refreshTotal();
    refreshJsonBody();
  }


  refreshList() {
    setState(() {
      orders = dbHelper.getOrders();
    });
  }

  refreshTotal() {
    setState(() {
      _totals = dbHelper.calculateTotal();
    });
  }

  refreshJsonBody() {
    setState(() {
      _jsonBody = dbHelper.getJsonOrder();
    });
  }

  void _removeQty({int foodsID}) async {
    int i;

    i = await dbHelper.removeQty(foodsID);

    refreshTotal();
    refreshList();
    refreshJsonBody();
  }

  void _addQty({int foodsID}) async {
    int i;
    i = await dbHelper.addQty(foodsID);
    refreshTotal();
    refreshList();
    refreshJsonBody();
  }

  //CODE HERE

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
                    MaterialPageRoute(builder: (context) => MyOrder()),
                  );
                },
                child: Text("OK"),
              )
            ],
          );
        });
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
      ),
    );
  }

  Widget _noOrder() {

    globals.hasMyOrder = "0";
    return new Card(
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Image.asset('assets/images/empty-cart.gif'),
      ),
    );
  }

  headerListOrder() {
    return Text(
      globals.restaurantName,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
      ),
    );
  }

  /// CODE1

  list() {
    return Expanded(
      child: FutureBuilder(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data.length == 0) {
                return _noOrder();
              } else {
 globals.hasMyOrder = "1";
           return new Container(
                  child: _ListSection(orders: snapshot.data),
                );
              }
            } else {
              //   return _noOrder();
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
            //   _order = snapshot.data;
          } else {
            //  return _noOrder();
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
        },
      ),
    );
  }

  Widget _ListSection({List<Order> orders}) => ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, int idx) {
          if (orders.length == 0) {
            return Padding(
              padding: EdgeInsets.all(2.0),
              child: Image.asset('assets/images/empty-cart.gif'),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                child: ListTile(

                  title: new Text(
                    orders[idx].foodsName.toString(),
                    style: TextStyle(
                      fontFamily: 'Kanit',
                    ),
                  ),
                  subtitle: new Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              'ราคา: ',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              orders[idx].price.toString().replaceAll('.0', ''),
                              style: TextStyle(
                                color: Colors.green,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                            child: Text(
                              'รวม: ',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              orders[idx].totalPrice.toString().replaceAll('.0', ''),
                              style: TextStyle(
                                color: Colors.green,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _removeQty(
                                        foodsID: orders[idx].foodsID)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(
                                  orders[idx].qty.toString(),
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: () =>
                                        _addQty(foodsID: orders[idx].foodsID)),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  trailing: null,
                ),
                decoration: new BoxDecoration(
                    border: Border(
                        bottom: new BorderSide(
                  color: Colors.cyan,
                  width: 0.5,
                  style: BorderStyle.solid,
                ))),
              ),
            );
          }
        },
      );

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
          globals.restaurantName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 20.0,
            fontFamily: 'Kanit',
          ),
        ),
      ),
      body: new  Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[

            list(),
            Row(children: <Widget>[
              Expanded(
                child: new RaisedButton(
                  color: Colors.white,
                  child: FutureBuilder(
                      future: _totals,
                      builder: (context, snapshot) {
                        return Text(
                          'รวมราคา  ${snapshot.data.toString().replaceAll('.0', '')}  บาท',
                          style: TextStyle(
                            color: Colors.black,
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
              Expanded(
                child: new RaisedButton(
                  color: Colors.pinkAccent,
                  child: FutureBuilder(
                      future: _jsonBody,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          jsonBody = snapshot.data;
                        }
                        return Text(
                          'สั่งอาหาร',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Kanit',
                          ),
                        );
                      }),
                  onPressed: () {
//CodeHere
                    String _Header =
                        '{"restaurantID":"${globals.restaurantID}","userID":"${globals.userID}","tableID":"100","latitude":"${globals.latitude}","longtitude":"${globals.longtitude}","orderList":[';
                    String _Tail = ']}';
                    String _All = '';
                    _All = _Header + jsonBody + _Tail;
                    ttt(_All);
                  },
                ),
              )
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
            //   new IconButton(icon: new Text('SAVE'), onPressed: null),

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

            new IconButton(
                icon: new Icon(Icons.list),
                color: Colors.white,
                onPressed: () {
                  if (globals.restaurantID != null) {
                    if (globals.restaurantID != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderHeader()),
                      );
                    } else {}
                  } else {}
                }),

            new IconButton(
                icon: new Icon(Icons.exit_to_app),
                color: Colors.white,
                onPressed: (){

                  AlertService tmp = new AlertService(title: 'Are you sure ?',desc: 'คุณต้องการออกจาก Application ใช่ไหม');
                  tmp.showAlertExit(context);
                //  showAlert(context);
                }),

          ],
        ),
      ),
    );
  }

  void _LogOut() {
      globals.restaurantID = "0";
      globals.hasMyOrder = "0";
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//      Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => FirstPage()),
    

  }

  void _dialogResult(String str) {
    if (str == 'Accept') {
      print('Accept');
    } else {
      Navigator.of(context).pop();
    }
  }

  _showAlertLogout(String strLogOut) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('ยังไม่สามารถ Logout ได้ ' + strLogOut),
            content: Text(""),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyOrder()),
                  );
                },
                child: Text("OK"),
              )
            ],
          );
        });
  }

  void _showAlert(BuildContext context, String value) {
    AlertDialog dialog = new AlertDialog(
      content: Text('คุณต้องการสั่งอาหาร ?'),
      actions: <Widget>[
        FlatButton(
            onPressed: () => _dialogResult('Cancel'), child: Text('Cancel')),
        FlatButton(
            onPressed: () {
              _dialogResult('Accept');
            },
            child: Text('Accept'))
      ],
    );

    showDialog(
      context: context,
      child: dialog,
      barrierDismissible: true,
    );
  }

  showAlertDialog(BuildContext context, String strJson) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        ttt(strJson);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => null,
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void ttt(String strAll) async {
    var feed = await NetworkFoods.inSertOrder(strBody: strAll);
    var data = DataFeed(feed: feed);
    if (data.feed.ResultOk.toString() == "true") {
      dbHelper.deleteAll();
      globals.hasMyOrder = "0";
      refreshList();
      refreshTotal();
      refreshJsonBody();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderHeader()),
      );
    } else {
    //  showSnak();
    }
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

class DataFeedCancel {
  RetCancelOrder feed;

  DataFeedCancel({this.feed});
}

class DataFeedJson {
  strJsonOrder feed;

  DataFeedJson({this.feed});
}

class DataFeedLogout {
  LogoutTable feed;

  DataFeedLogout({this.feed});
}

class DataFeedReCheck {
  retCheckBillStatus feed;

  DataFeedReCheck({this.feed});
}
