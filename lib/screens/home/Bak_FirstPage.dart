import 'package:emenu_covid/screens/home/MyOrder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:emenu_covid/models/order.dart';
import 'dart:async';
import 'package:emenu_covid/screens/home/FirstPage.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/sqlite/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emenu_covid/services/authService.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/models/restaurant.dart';
import 'package:emenu_covid/models/logout.dart';
import 'package:emenu_covid/models/information.dart';
import 'package:emenu_covid/screens/home/profile.dart';
import 'package:emenu_covid/screens/home/DetailCommendPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:emenu_covid/services/AlertForm.dart';
import 'dart:convert';
import 'package:condition/condition.dart';

int foodsID;
String foodsName;
double price;
String size;
String description;
String images;
int qty;
String taste;

String iTest = '';

String _restaurantID = globals.restaurantID;
String close_time;
String open_time;


Future<Information> resultInformation;

void main() {
  runApp(B_FirstPage());
}

class B_FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowData();
  }
}

class _ShowData extends State<B_FirstPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _checkDateTimeCurfuse();
    _getInformation();
  }


  _checkDateTimeCurfuse() {
    String DateTimeformatted1;
    String DateTimeformatted2;

    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    final tClose = Duration(hours: 21, minutes: 00); // 21:00
    final tOpen = Duration(hours: 04, minutes: 00); // 04:00

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String Dateformatted = formatter.format(now);

    DateTimeformatted1 = Dateformatted + ' ' + format(tClose);
    DateTimeformatted2 = Dateformatted + ' ' + format(tOpen);
    DateTime dtClose = DateTime.parse(DateTimeformatted1);
    DateTime dtOpen = DateTime.parse(DateTimeformatted2);

    if (DateTime.now().isAfter(dtClose) &&
        DateTime.now().isBefore(dtOpen.add(new Duration(days: 1)))) {
      globals.curfew = "1";
      if (globals.showDialogFirstRun == "0") {
        globals.showDialogFirstRun == "1";
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _onAlertFirstRun(context));
      }
    } else {
      globals.curfew = "0";
    }
  }

  listRestaurant() {
    return Expanded(
      child: FutureBuilder<Restaurant>(
        future: NetworkFoods.loadRestaurant(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return new Container(
                child: _listCard(Mrestaurant: snapshot.data),
              );
            } else {
              return Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        height: 0.0,
                        width: 0.0,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator(),
                      height: 0.0,
                      width: 0.0,
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

  var alertStyleFirstRun = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(
        fontWeight: FontWeight.normal, fontFamily: 'Kanit', fontSize: 14),
    animationDuration: Duration(milliseconds: 400),
//
//    alertBorder: RoundedRectangleBorder(
//      borderRadius: BorderRadius.circular(10.0),
//      side: BorderSide(
//        color: Colors.grey,
//      ),
//    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
  );
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(
        fontWeight: FontWeight.normal, fontFamily: 'Kanit', fontSize: 14),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
  );


  _onAlert(context) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Are you sure ?",
      desc: "คุณมีรายการอาหารที่เลือกไว้จากร้านเดิม ต้องการลบทิ้งใช่ไหม?.",
      style: alertStyle,
      buttons: [
        DialogButton(
            child: Text(
              "CANCEL",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Kanit',
              ),
            ),
            onPressed: () {
              globals.restaurantID = globals.tmpRestaurantID;
              globals.currentRestaurant = globals.tmpRestaurantID;
              globals.restaurantTel = globals.newRestaurantTel;
              Navigator.of(context, rootNavigator: true)
                  .pushNamed('/FirstPage');
            }),
        DialogButton(
          child: Text(
            "DELETE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Kanit',
            ),
          ),
          onPressed: () {
            //Delete

            dbHelper.deleteAll();
            globals.restaurantID = globals.newRestaurantID;
            globals.currentRestaurant = globals.newRestaurantID;
            globals.restaurantName = globals.newRestaurantName.toString();
            globals.restaurantTel = globals.newRestaurantTel;
            globals.hasMyOrder = "0";
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<bool>(
                fullscreenDialog: true,
                builder: (BuildContext context) => DetailCommendPage(restaurantID: globals.newRestaurantID.toString(),
                  tel: globals.restaurantTel.toString(),

                ),
              ),
            );

            //  Navigator.of(context, rootNavigator: true).pop();
          },
          color: Colors.red,
        )
      ],
    ).show();
  }

  _onAlertFirstRun(context) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "COVID-19",
      desc:
      "เนื่องด้วยสถานการณ์โควิดที่เกินขึ้นตอน APP จะเปิดให้สั่งอาหารได้เฉพาะ ช่วงเวลา 21:00 - 04:00",
      style: alertStyleFirstRun,
      buttons: [
        DialogButton(
            child: Text(
              "OK",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Kanit',
              ),
            ),
            color: Colors.pinkAccent,
            onPressed: () {
              globals.showDialogFirstRun = "1";

              Navigator.of(context, rootNavigator: true)
                  .pushNamed('/FirstPage');
            }),
      ],
    ).show();
  }

  Widget HeaderColumn() {
    return new Container(
      height: 0,
      child: new ListTile(
        onTap: null,
      ),
    );
  }

  Widget _listCard({Restaurant Mrestaurant}) => ListView.separated(
      separatorBuilder: (context, idx) => SizedBox(
        height: 10,
      ),
      itemCount: Mrestaurant.data.length,
      itemBuilder: (context, idx) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            margin: const EdgeInsets.only(left: 2, right: 2),
            child: Container(
              color: Colors.yellow,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 200.0,
                    width: 340.0,
                    child: Image.asset(
                      "assets/images/plate3.png",
                      scale: 0.8,
                    ),
                  ),



                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      height: 60.0,
                      width: 340.0,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.black12,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          )),
                    ),
                  ),




                  Positioned(
                    left: 10.0,
                    bottom: 170.0,
                    child: Row(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 270,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    Mrestaurant.data[idx].open_close,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Kanit',
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),



                  Positioned(
                    left: 8.0,
                    bottom: 0.0,
                    child: Row(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 270,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    Mrestaurant.data[idx].restaurantName,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Kanit',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16.0,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16.0,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16.0,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16.0,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16.0,
                                  ),
                                  Text(
                                    '  ${Mrestaurant.data[idx].distance.toString()} KM',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '  ${Mrestaurant.data[idx].open_time.toString().substring(0, 5)} - ${Mrestaurant.data[idx].close_time.toString().substring(0, 5)}',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: ButtonTheme(
                            height: 25,
                            minWidth: 80,
                            child: FlatButton(
                              color: Colors.pinkAccent,
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(5.0),
                              splashColor: Colors.grey,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () {

                                open_time = Mrestaurant.data[idx].open_time.toString();
                                close_time = Mrestaurant.data[idx].close_time.toString();


                                if (["", null, false, 0].contains(globals.currentRestaurant)) {
                                  globals.restaurantName = Mrestaurant.data[idx].restaurantName.toString();
                                  globals.restaurantID = Mrestaurant.data[idx].restaurantID.toString();
                                  globals.currentRestaurant = Mrestaurant.data[idx].restaurantID.toString();
                                  globals.restaurantTel = Mrestaurant.data[idx].tel.toString();
                                  globals.openTimeRest = Mrestaurant.data[idx].open_time.toString();
                                  globals.closeTimeRest = Mrestaurant.data[idx].close_time.toString();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailCommendPage(
                                        restaurantID: Mrestaurant.data[idx].restaurantID.toString(),
                                        tel: Mrestaurant.data[idx].tel.toString(),open_time: Mrestaurant.data[idx].open_time.toString(),
                                        close_time: Mrestaurant.data[idx].close_time.toString(),
                                      ),
                                    ),
                                  );
                                } else {
                                  if (globals.currentRestaurant.toString() != Mrestaurant.data[idx].restaurantID.toString() && globals.hasMyOrder == "1")
                                  {
                                    globals.tmpRestaurantID = globals.currentRestaurant.toString();
                                    globals.newRestaurantID = Mrestaurant.data[idx].restaurantID.toString();
                                    globals.newRestaurantName = Mrestaurant.data[idx].restaurantName.toString();
                                    globals.newRestaurantTel = Mrestaurant.data[idx].tel.toString();
                                    globals.openTimeRest = Mrestaurant.data[idx].open_time.toString();
                                    globals.closeTimeRest = Mrestaurant.data[idx].close_time.toString();
                                    _onAlert(context);
                                  } else {
                                    globals.restaurantID = Mrestaurant.data[idx].restaurantID.toString();
                                    globals.restaurantName = Mrestaurant.data[idx].restaurantName.toString();
                                    globals.currentRestaurant = Mrestaurant.data[idx].restaurantID.toString();
                                    globals.restaurantTel = Mrestaurant.data[idx].tel.toString();
                                    globals.openTimeRest = Mrestaurant.data[idx].open_time.toString();
                                    globals.closeTimeRest = Mrestaurant.data[idx].close_time.toString();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailCommendPage(
                                          restaurantID: Mrestaurant.data[idx].restaurantID,
                                          tel: Mrestaurant.data[idx].tel,
                                          open_time: Mrestaurant.data[idx].open_time,
                                          close_time:  Mrestaurant.data[idx].close_time,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                "รายละเอียด",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                padding: EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
                child: Image.asset(
                  'assets/images/CovidFoodLogoBar.png',
                  fit: BoxFit.cover,
                  //  height: 240.0,
                )),
            // HeaderColumn(),
            listRestaurant(),
          ],
        ),
      ),
    );
  }

  void _LogOut() async {
    if (globals.tableID != null && globals.tableID != '') {
      String strBody =
          '{"userID":"${globals.userID}","tableID":"${globals.tableID}"}';
      var feed = await NetworkFoods.loadLogout(strBody);
      var data = DataFeedLogout(feed: feed);
      if (data.feed.ResultOk == "false") {
      } else {
        globals.tableID = '';
        globals.tableName = '';
        globals.restaurantID = '';
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstPage()),
        );
      }
    } else {
      globals.tableID = '';
      globals.tableName = '';
      globals.restaurantID = '';
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FirstPage()),
      );
    }
  }


  void _getInformation() async {
    var feed = await NetworkFoods.loadInformation();
    var data = DataFeed(feed: feed);
    if (data.feed.ResultOk == "True") {

    }

  }
}



class DataFeedLogout {
  LogoutTable feed;
  DataFeedLogout({this.feed});
}

class DataFeed {
  Information feed;
  DataFeed({this.feed});
}
