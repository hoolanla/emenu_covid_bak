import 'package:emenu_covid/models/orderDetail.dart';
import 'package:flutter/material.dart';
import 'package:emenu_covid/models/order.dart';
import 'package:emenu_covid/models/flagDelivery.dart';
import 'dart:async';
import 'package:emenu_covid/screens/home/FirstPage.dart';
import 'package:emenu_covid/screens/home/OrderHeader.dart';
import 'package:emenu_covid/screens/home/MyOrder.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/sqlite/db_helper.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/models/bill.dart';
import 'package:emenu_covid/screens/home/DetailCommendPage.dart';
import 'package:emenu_covid/models/logout.dart';
import 'package:emenu_covid/services/AlertForm.dart';
import 'package:emenu_covid/screens/admin/OrderHeaderToday.dart';

//String _restaurantID = globals.restaurantID;
//String _tableID = globals.tableID;
//String _userID = globals.userID;

Future<List<Order>> orders;
Future<ResultOrderDetail> resultOrderDetail;
List<Order> _order;
Future<double> _totals;

Future<String> _jsonBody;
String jsonBody;

Future<resultUpdateFlagDelivery> retInsert;
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
  runApp(OrderDetailTodayPage());
}

class OrderDetailTodayPage extends StatefulWidget {
  final String orderID;
  final String restaurantID;

  OrderDetailTodayPage({this.orderID, this.restaurantID});

  @override
  State<StatefulWidget> createState() {
    return _ShowData();
  }
}

class _ShowData extends State<OrderDetailTodayPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//  String strBody = '{"orderID":"{$}"}';

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
                    MaterialPageRoute(builder: (context) => OrderDetailTodayPage()),
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

    refreshOrderDetail();
    refreshTotalDetail();
  }

  showSnak() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("ไม่สามารถสั่งได้ กำลงัเคลียร์โต๊ะ"),
      backgroundColor: Colors.deepOrange,
      duration: Duration(seconds: 2),
    ));
  }

  refreshOrderDetail() {
    String strBody =
        '{"orderNo":"${widget.orderID}","restaurantID":"${widget.restaurantID}"}';
    setState(() {
      resultOrderDetail = NetworkFoods.loadOrderDetail(strBody);
    });
  }

  refreshTotalDetail() {

    String strBody =
        '{"orderNo":"${widget.orderID}","restaurantID":"${widget.restaurantID}"}';
    setState(() {
      _totals = NetworkFoods.loadTotalOrderDetail(strBody);

    });
  }

  refreshJsonBody() {
    setState(() {
      _jsonBody = dbHelper.getJsonOrder();
    });
  }

  //CODE HERE

  Widget _ListSectionStatus({ResultOrderDetail menu}) => ListView.builder(
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

                  title: Text(
                    menu.orderList[idx].foodsName.toString(),
                    style: TextStyle(
                      fontFamily: 'Kanit',
                    ),
                  ),
                  subtitle: new Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Text(
                            menu.orderList[idx].qty.toString() + 'x',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '   ราคา: ' +
                                menu.orderList[idx].price.toString() +
                                ' บาท',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
//                          new Row(
//                            children: <Widget>[
//                              Padding(
//                                padding: const EdgeInsets.all(0.0),
//                                child: Text(
//                                  'CANCEL: ',
//                                  style: TextStyle(
//                                    fontFamily: 'Kanit',
//                                  ),
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(0.0),
//                                child: IconButton(
//                                  icon: Icon(
//                                    Icons.delete,
//                                    color: Colors.red,
//                                  ),
//                                  onPressed: () {
//                                    SendtoJsonCancel(
//                                        orderID: menu.orderList[idx].orderID);
//                                  },
//                                ),
//                              ),
//                            ],
//                          )
                    ],
                  ),
                  trailing: Text(
                    menu.orderList[idx].totalPrice.toString(),
                    style: TextStyle(
                      fontFamily: 'Kanit',
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
      child: FutureBuilder<ResultOrderDetail>(
          future: resultOrderDetail,
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
        ),
        backgroundColor: Colors.cyan,
        title: new Text(
          'รายละเอียด',
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
                  color: Colors.white,
                  child: FutureBuilder(
                      future: _totals,
                      builder: (context, snapshot) {
                        return Text(
                          'รวมราคา  ${snapshot.data.toString().replaceAll('.0', '')} บาท',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Kanit',
                          ),
                        );
                      }),
                  onPressed: () {},
                ),
              ),

              Expanded(
                child: new RaisedButton(
                  color: Colors.pinkAccent,
                  child: Text(
                          'รับออเดอร์',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Kanit',
                          ),
                        ),
                  onPressed: () {
//CodeHere
                    String strBody =
                        '{"orderID":"${widget.orderID}","value":"1"}';
                    ttt(strBody);
                  },
                ),
              )



            ])
          ],
        ),
      ),

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
          'ราคา ',
          style: TextStyle(
            fontFamily: 'Kanit',
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }



  void _dialogResult(String str) {
    if (str == 'Accept') {
    } else {
      Navigator.of(context).pop();
    }
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

    var feed = await NetworkFoods.updateFlagDelivery(strBody: strAll);
    var data = DataFeed(feed: feed);
    if (data.feed.ResultOk.toString() == "true") {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderHeaderToday()),
      );

    } else {
      showSnak();
    }
  }
}

class DataFeed {
  resultUpdateFlagDelivery feed;
  DataFeed({this.feed});
}






