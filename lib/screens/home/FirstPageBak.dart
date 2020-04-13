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
  runApp(FirstPageBak());
}

class FirstPageBak extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShowData();
  }
}

class _ShowData extends State<FirstPageBak> {
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

  _onAlert(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "",
      desc: "คุณมีรายการอาหารที่เลือกไว้จากร้านเดิม ต้องการลบทิ้งใช่ไหม?.",
      buttons: [
        DialogButton(
            child: Text(
              "CANCEL",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Kanit',
              ),
            ),
            onPressed: (){

              globals.restaurantID = globals.tmpRestaurantID;
              globals.currentRestaurant = globals.tmpRestaurantID;
    Navigator.of(context, rootNavigator: true).pushNamed('/FirstPage');
            }),
         
        DialogButton(
          child: Text(
            "DELETE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Kanit',
            ),
          ),
          onPressed: () {


            //Delete

            dbHelper.deleteAll();
            globals.restaurantID = globals.newRestaurantID;
            globals.currentRestaurant = globals.newRestaurantID;
          globals.restaurantName = globals.newRestaurantName.toString();
            print('New ' + globals.newRestaurantID.toString());
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<bool>(
                fullscreenDialog: true,
                builder: (BuildContext context) => DetailCommendPage(restaurantID: globals.newRestaurantID.toString(),),
              ),
            );


          //  Navigator.of(context, rootNavigator: true).pop();
            },
          color: Colors.red,
        )
      ],
    ).show();
  }

  Widget _listCard({Restaurant Mrestaurant}) => ListView.builder(
      itemCount: Mrestaurant.data.length,
      itemBuilder: (context, idx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 2, 0.0, 2),
          child: Container(
              height: 180.0,
              width: 420.0,
              decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: NetworkImage(Mrestaurant.data[idx].images),
//                    fit: BoxFit.cover),
                  ),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 180.0,
                    width: 420.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.1), Colors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Spacer(),
                        Text(
                          '${Mrestaurant.data[idx].restaurantName}',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.normal,
                              fontSize: 24.0,
                              letterSpacing: 1.1),
                        ),
                        Text(
                          '${Mrestaurant.data[idx].content}',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Kanit',
                              fontSize: 16.0,
                              letterSpacing: 1.1),
                        ),
                        Spacer(),

                        ButtonTheme(
                          height: 28,
                          minWidth: 110,
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

                                if (globals.currentRestaurant.toString() != Mrestaurant.data[idx].restaurantID.toString()) {

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
                                fontSize: 14.0,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
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
//      bottomNavigationBar: new BottomAppBar(
//        child: new Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
//            new IconButton(
//                icon: new Icon(Icons.home),
//                onPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => FirstPage2()),
//                  );
//                }),
//            //   new IconButton(icon: new Text('SAVE'), onPressed: null),
//
//            new IconButton(
//                icon: new Icon(Icons.restaurant),
//                onPressed: () {
//                  if (globals.restaurantID != null) {
//                    if (globals.restaurantID != '') {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => null),
//                      );
//                    }
//                  }
//                }),
//
//            new IconButton(
//                icon: new Icon(Icons.list),
//                onPressed: () {
//                  if (globals.restaurantID != null) {
//                    if (globals.restaurantID != '') {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => null),
//                      );
//                    }
//                  }
//                }),
//
//            new IconButton(
//                icon: new Icon(Icons.history),
//                onPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => null),
//                  );
//                }),
////            new IconButton(
////                icon: new Icon(Icons.map),
////                onPressed: () {
////                  Navigator.push(
////                    context,
////                    MaterialPageRoute(builder: (context) => Mapgoogle()),
////                  );
////                }),
//
//            new IconButton(
//                icon: new Icon(Icons.person_outline),
//                onPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => Profile()),
//                  );
//                }),
//            new IconButton(
//                icon: new Icon(Icons.exit_to_app),
//                onPressed: () {
//                  _LogOut();
//                }),
//          ],
//        ),
//      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
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
