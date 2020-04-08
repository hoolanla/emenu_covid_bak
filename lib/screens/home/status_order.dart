import 'package:flutter/material.dart';

import 'package:emenu_covid/screens/home/FirstPage2.dart';
import 'package:emenu_covid/models/foods.dart';
import 'package:emenu_covid/models/order.dart';
import 'package:emenu_covid/models/bill.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'dart:async' show Future;

import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/screens/home/profile.dart';

String _restaurantID = globals.restaurantID;
String _tableID = globals.tableID;
String _userID = globals.userID;

void main() {
  runApp(Status_Order());
}

class Status_Order extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '',
      home: new MyStateful(),
//      initialRoute: '/',
//      routes: {
//        '/home': (context) => Home(),
//      },
    );
  }
}

class MyStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyStatefulState();
  }
}

class _MyStatefulState extends State<MyStateful>
    with SingleTickerProviderStateMixin {


  TabController controller;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final titleString = "THE CORR";

  @override
  void initState() {
    super.initState();

    controller = new TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String strBody;

    strBody =
    '{"restaurantID":"${_restaurantID}","tableID":"${_tableID}","userID":"${_userID}"}';

    void _showAlertDialog({String strError}) async {
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
                    Navigator.pop(context);
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
          '{"restaurantID":"${_restaurantID}","tableID":"${_tableID}","userID":"${_userID}"}';
      var feed = await NetworkFoods.checkBill(strBody: strBody);
      var data = DataFeed(feed: feed);
      if (data.feed.ResultOk.toString() == "true") {
      } else {
        _showAlertDialog(strError: 'กำลังเคลียร์โต๊ะ !!');
      }
    }

    return new Scaffold(
      appBar: new AppBar(
        textTheme: TextTheme(
            title: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            )),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          'MENU',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: Colors.white,
        label: Text(
          'CHECK BILL',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          SendtoJsonCheckbill(
              restaurantID: _restaurantID, tableID: _tableID, userID: _userID);
        },
      ),
      //  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);

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
                icon: new Icon(Icons.center_focus_strong),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                }),




            new IconButton(
                icon: new Icon(Icons.list),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => null),
                  );
                }),
            new IconButton(
                icon: new Icon(Icons.alarm),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Status_Order()),
                  );
                }),
          ],
        ),
      ),
      body: FutureBuilder<StatusOrder>(
          future: NetworkFoods.loadStatusOrder(strBody),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              return new Container(
                child: _ListSection(menu: snapshot.data),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          }),
    );
  }

  List<detailFood> detailFoods = [];

  SendtoJsonCancel({String orderID}) async {
    String strBody = '{"orderID":"${orderID}"}';
    var feed = await NetworkFoods.cancelOrder(strBody: strBody);
    var data = DataFeedCancel(feed: feed);
    if (data.feed.ResultOk.toString() == "true") {
    } else {}
  }

  Widget _ListSection({StatusOrder menu}) => ListView.builder(
    itemBuilder: (context, int idx) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: new ListTile(
                leading: Image.network('${menu.orderList[idx].image}'),
                title: Text('ราคา: ' +
                    menu.orderList[idx].price.toString() +
                    '    จำนวนวน: ' +
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
}

Widget changeIcon({String status}) {
  print(status);

  if (status == "Pending") {
    return Icon(
      //Icons.forward_5,
      Icons.restaurant,
      color: Colors.green,
    );
  } else if (status == "Complete") {
    return Icon(
      Icons.done_outline,
      color: Colors.green,
    );
  } else {
    //Close
    return Icon(
      Icons.note,
      color: Colors.green,
    );
  }
}

class DataFeed {
  RetBill feed;

  DataFeed({this.feed});
}

class DataFeedCancel {
  RetCancelOrder feed;
  DataFeedCancel({this.feed});
}
