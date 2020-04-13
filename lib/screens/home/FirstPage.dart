import 'package:emenu_covid/screens/home/MyOrder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:emenu_covid/models/order.dart';
import 'dart:async';
import 'package:emenu_covid/screens/home/FirstPage.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/sqlite/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emenu_covid/services/authService.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/models/restaurant.dart';
import 'package:emenu_covid/models/logout.dart';
import 'package:emenu_covid/screens/home/profile.dart';
import 'package:emenu_covid/screens/home/DetailCommendPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';

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

void main() {
  runApp(FirstPage());
}

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowData();
  }
}

class _ShowData extends State<FirstPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
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

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.normal,fontFamily: 'Kanit',fontSize: 14),
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
            globals.hasMyOrder = "0";
            print('New ' + globals.newRestaurantID.toString());
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<bool>(
                fullscreenDialog: true,
                builder: (BuildContext context) => DetailCommendPage(
                  restaurantID: globals.newRestaurantID.toString(),
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


  Widget HeaderColumn() {
    return new Container(
      height: 1.5,
      child: new ListTile(
        onTap: null,
      ),
    );
  }
  Widget _listCard({Restaurant Mrestaurant}) => ListView.separated(
    separatorBuilder: (context,idx) => SizedBox(
      height: 3,

    ),
      itemCount: Mrestaurant.data.length,
      itemBuilder: (context, idx) {
        return ClipRRect(

          borderRadius: BorderRadius.circular(15),

          child: Container(
            margin: const EdgeInsets.only(left: 2,right: 2),
            child: Container(

              color: Colors.orange[100],
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
                              color: Colors.deepOrange,
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(5.0),
                              splashColor: Colors.deepOrange,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                print('Step1 ==');
                                print('curent ==' + globals.currentRestaurant.toString());
                                print('restID ==' + globals.restaurantID.toString());
                                print('name ==' + globals.restaurantName.toString());
                                print('========================');

                                if (["", null, false, 0].contains(globals.currentRestaurant)) {


                                  globals.restaurantName = Mrestaurant.data[idx].restaurantName.toString();
                                  globals.restaurantID = Mrestaurant.data[idx].restaurantID.toString();
                                  globals.currentRestaurant = Mrestaurant.data[idx].restaurantID.toString();
                                  print('Step2 current null ==');
                                  print('curent ==' + globals.currentRestaurant.toString());
                                  print('restID ==' + globals.restaurantID.toString());
                                  print('name ==' + globals.restaurantName.toString());
                                  print('========================');


                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailCommendPage(
                                        restaurantID:
                                        Mrestaurant.data[idx].restaurantID.toString(),
                                      ),
                                    ),
                                  );


                                } else {

                                  if (globals.currentRestaurant.toString() != Mrestaurant.data[idx].restaurantID.toString() && globals.hasMyOrder == "1") {

                                    print('step 3  If diff');
                                    print('curent ==' + globals.currentRestaurant.toString());
                                    print('new  ==' + Mrestaurant.data[idx].restaurantID.toString());
                                    print('restID ==' + globals.restaurantID.toString());
                                    print('name ==' + globals.restaurantName.toString());
                                    print('========================');

                                    globals.tmpRestaurantID = globals.currentRestaurant.toString();
                                    globals.newRestaurantID = Mrestaurant.data[idx].restaurantID.toString();
                                    globals.newRestaurantName = Mrestaurant.data[idx].restaurantName.toString();
                                    _onAlert(context);
                                  }
                                  else
                                  {
                                    globals.restaurantID = Mrestaurant.data[idx].restaurantID.toString();
                                    globals.restaurantName = Mrestaurant.data[idx].restaurantName.toString();
                                    globals.currentRestaurant = Mrestaurant.data[idx].restaurantID.toString();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailCommendPage(
                                          restaurantID:
                                          Mrestaurant.data[idx].restaurantID,
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
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: new Text(
          'COVID FOOD',
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
}

class DataFeedLogout {
  LogoutTable feed;

  DataFeedLogout({this.feed});
}
