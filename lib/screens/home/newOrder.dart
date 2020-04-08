import 'package:flutter/material.dart';
import 'package:emenu_covid/models/order.dart';
import 'dart:async';
import 'package:emenu_covid/screens/home/FirstPage2.dart';
import 'package:emenu_covid/screens/home/status_order.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/sqlite/db_helper.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/models/bill.dart';
import 'package:emenu_covid/screens/home/DetailCommendPage.dart';
import 'package:emenu_covid/models/logout.dart';

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
  runApp(newOrder());
}

class newOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowData();
  }
}

class _ShowData extends State<newOrder> {
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
                    MaterialPageRoute(builder: (context) => newOrder()),
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
      refreshStatusOrder();
      refreshJsonBody();
      refreshTotalCheckbill();

  }

  showSnak() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("ไม่สามารถสั่งได้ กำลงัเคลียร์โต๊ะ"),
      backgroundColor: Colors.deepOrange,
      duration: Duration(seconds: 2),
    ));
  }

  refreshList() {
    setState(() {
      orders = dbHelper.getOrders();
    });
  }

  refreshStatusOrder() {
    setState(() {
      statusOrders = NetworkFoods.loadStatusOrder(strBody);
    });
  }

  refreshTotalCheckbill() {
    setState(() {
      _totalsCheckbill = NetworkFoods.loadTotalStatusOrder(strBody);
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

// void refreshJsonBody() async {
//
//      _jsonBody = await dbHelper.getJsonOrder();
//
//  }

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
  SendtoJsonCancel({String orderID}) async {
    String strBody =
        '{"restaurantID":"${globals.restaurantID}","userID":"${globals.userID}","tableID":"${globals.tableID}"}';

    var feed1 = await NetworkFoods.loadRetCheckBillStatus(strBody);
    var data1 = DataFeedReCheck(feed: feed1);

    if (data1.feed.ResultOk == 'false') {
      String strBody2 = '{"orderID":"${orderID}"}';
      var feed = await NetworkFoods.cancelOrder(strBody: strBody2);
      var data = DataFeedCancel(feed: feed);
      if (data.feed.ResultOk.toString() == "true") {
        refreshStatusOrder();
        refreshTotalCheckbill();
        refreshJsonBody();
      } else {
        _showAlertDialog2(strError: 'ไม่สามารถ Cancel ได้  ' + data.feed.ErrorMessage);
      }
    } else {
      _showAlertDialog2(
          strError: 'โต๊ะนี้อยู่ในระหว่างเช็คบิล คุณไม่สามารถ Cancel อาหารได้');
    }
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
                    MaterialPageRoute(builder: (context) => newOrder()),
                  );
                },
                child: Text("OK"),
              )
            ],
          );
        });
  }

  void SendtoJsonCheckbill(
      {String restaurantID, String tableID, String userID}) async {
    String strBody =
        '{"restaurantID":"${globals.restaurantID}","tableID":"${globals.tableID}","userID":"${globals.userID}"}';
    var feed = await NetworkFoods.checkBill(strBody: strBody);
    var data = DataFeedBill(feed: feed);
    if (data.feed.ResultOk.toString() == "true") {
      //CODE HERE
      dbHelper.deleteAll();

      _showAlertDialog(strError: 'แจ้งเช็คบิลล์แล้ว');
    } else {
      _showAlertDialog(strError: 'กำลังดำเนินการเช็คบิลล์ โปรดรอสักครู่');
    }
  }

  Widget _ListSectionStatus({StatusOrder menu}) => ListView.builder(
    itemBuilder: (context, int idx) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: new ListTile(
                leading: Icon(Icons.fastfood,size: 20,color: Colors.redAccent,),
                title: Text('ราคา: ' +
                    menu.orderList[idx].price.toString() +
                    '    จำนวน: ' +
                    menu.orderList[idx].qty.toString()),
                subtitle: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        Text('รวมราคา: ' +
                            menu.orderList[idx].totalPrice.toString())
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text('CANCEL: '),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              SendtoJsonCancel(
                                  orderID: menu.orderList[idx].orderID);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                trailing: changeIcon(status: menu.orderList[idx].status),
              ),
            ),
          ],
        ),
      );
    },
    itemCount: menu.orderList.length,
  );

  Widget _noOrder() {
    return new Card(
//      child: null,
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(10.0),
//      ),
//      elevation: 5,
//      margin: EdgeInsets.all(10),
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

  /// CODE1

  listStatusOrder() {
    return Expanded(

      child: FutureBuilder<StatusOrder>(
          future: statusOrders,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (snapshot.data.orderList.length == 0) {
                  return _noOrder();
                } else {
                  return new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Expanded(
                        child: _ListSectionStatus(menu: snapshot.data),
                      ),
                      new ButtonBar(
                        children: <Widget>[
                          new RaisedButton(
                            color: Colors.white,
                            child: FutureBuilder(
                                future: _totalsCheckbill,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data != null) {
                                      return Text(
                                        'Total ${snapshot.data} || REFRESH',
                                        style: TextStyle(color: Colors.black),
                                      );
                                    } else {
                                      return Container(
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                child:
                                                CircularProgressIndicator(),
                                                height: 10.0,
                                                width: 10.0,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Container(
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              child:
                                              CircularProgressIndicator(),
                                              height: 10.0,
                                              width: 10.0,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            onPressed: () {
                              refreshStatusOrder();
                              refreshTotalCheckbill();
                            },
                          ),
                          new RaisedButton(
                            color: Colors.deepOrange,
                            child: FutureBuilder(
                                future: _totals,
                                builder: (context, snapshot) {
                                  return Text(
                                    'CHECK BILL',
                                    style: TextStyle(color: Colors.black),
                                  );
                                }),
                            onPressed: () {
                              SendtoJsonCheckbill(
                                  restaurantID: globals.restaurantID,
                                  tableID: globals.tableID,
                                  userID: globals.userID);
                            },
                          ),
                        ],
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
                return new Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Expanded(
                      child: _ListSection(orders: snapshot.data),
                    ),
                    new ButtonBar(
                      children: <Widget>[
                        new RaisedButton(
                          color: Colors.white,
                          child: FutureBuilder(
                              future: _totals,
                              builder: (context, snapshot) {
                                return Text(
                                  'Total  ${snapshot.data}',
                                  style: TextStyle(color: Colors.black),
                                );
                              }),
                          onPressed: () {},
                        ),
                        new RaisedButton(
                          color: Colors.deepOrange,
                          child: FutureBuilder(
                              future: _jsonBody,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  jsonBody = snapshot.data;
                                }
                                return Text(
                                  'ORDER NOW',
                                  style: TextStyle(color: Colors.black),
                                );
                              }),
                          onPressed: () {
//CodeHere
                            String _Header =
                                '{"restaurantID":"${globals.restaurantID}","userID":"${globals.userID}","tableID":"100","latitude":"${globals.latitude}","longtitude":"${globals.longtitude}","orderList":[';
                            String _Tail = ']}';
                            String _All = '';
                            _All = _Header + jsonBody + _Tail;

                            print(_All);

                            ttt(_All);
                          },
                        ),
                      ],
                    ),
                  ],
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
            //  child: Image.asset('assets/images/empty-cart.gif'),
            child: Image.network(
                'https://i2.wp.com/www.teleanalysis.com/wp-content/uploads/2018/08/jio-data-consumption-issue-e1533921963505.png?fit=475%2C288&ssl=1'),
          );
        } else {
          return ListTile(
            leading: Icon(Icons.fastfood,color: Colors.redAccent,size: 20.0,),
            title: new Text(orders[idx].foodsName.toString()),
            subtitle: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text('ราคา:'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        orders[idx].price.toString(),
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                      child: Text('รวม:'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        orders[idx].totalPrice.toString(),
                        style: TextStyle(color: Colors.green),
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
                              onPressed: () =>
                                  _removeQty(foodsID: orders[idx].foodsID)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            orders[idx].qty.toString(),
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
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
          );
        }
      });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          backgroundColor: Colors.white,
          title: new Text(
            'MY ORDER',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        bottomNavigationBar: new BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.home),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstPage2()),
                    );
                  }),
              //   new IconButton(icon: new Text('SAVE'), onPressed: null),

              new IconButton(
                  icon: new Icon(Icons.restaurant),
                  onPressed: () {
                    if (globals.restaurantID != null) {
                      if (globals.restaurantID != '') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailCommendPage(
                                restaurantID: globals.restaurantID,
                              )),
                        );
                      } else {
                        _showAlertDialog();
                      }
                    } else {
                      _showAlertDialog();
                    }
                  }),

              new IconButton(
                  icon: new Icon(Icons.list),
                  onPressed: () {
                    if (globals.restaurantID != null) {
                      if (globals.restaurantID != '') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => newOrder()),
                        );
                      } else {
                        _showAlertDialog();
                      }
                    } else {
                      _showAlertDialog();
                    }
                  }),


              new IconButton(
                  icon: new Icon(Icons.exit_to_app),
                  onPressed: () {
                    _LogOut();
                  }),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: new Container(
            child: new Column(

              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,

              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                headerListOrder(),
                Container(

                    height: MediaQuery.of(context).size.width,
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        list(),
                      ],
                    )),
                SizedBox(
                  height: 12,
                ),
                headerStatusOrder(),
                Container(
                  height: MediaQuery.of(context).size.width,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      listStatusOrder(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _LogOut() async {
    if (globals.tableID != null && globals.tableID != '') {
      String strBody =
          '{"userID":"${globals.userID}","tableID":"${globals.tableID}"}';
      var feed = await NetworkFoods.loadLogout(strBody);
      var data = DataFeedLogout(feed: feed);
      if (data.feed.ResultOk == "false") {
        _showAlertLogout(data.feed.ErrorMessage);
      } else {
        globals.tableID = '';
        globals.restaurantID = '';
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstPage2()),
        );
      }
    } else {
      globals.tableID = '';
      globals.restaurantID = '';
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FirstPage2()),
      );
    }
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
                    MaterialPageRoute(builder: (context) => newOrder()),
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
    print('================> ' + strAll);

    var feed = await NetworkFoods.inSertOrder(strBody: strAll);
    var data = DataFeed(feed: feed);
    if (data.feed.ResultOk.toString() == "true") {
      dbHelper.deleteAll();
      refreshList();
      refreshTotal();
      refreshStatusOrder();
      refreshTotalCheckbill();
      refreshJsonBody();
    } else {
      showSnak();
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
