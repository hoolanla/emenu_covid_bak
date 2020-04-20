import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:emenu_covid/screens/home/webView.dart';
import 'package:emenu_covid/screens/login/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:emenu_covid/globals.dart' as globals;

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MainLogin(),
  ));
}

class MainLogin extends StatefulWidget {
  @override
  MainLoginState createState() => new MainLoginState();
}

class MainLoginState extends State<MainLogin> {
  int counter = 0;
  List<String> strings = ["Flutter", "Is", "Awesome"];
  String displayedString = "";
  String _locationMessage = "";

  void _getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
      globals.latitude = "${position.latitude}";
      globals.longtitude = "${position.longitude}";
    });
  }

  void gotoWebView() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new WebView_Flutter()));
  }

  void gotoLoginApp() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new Login()));
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
            child: new Center(
                child: new Column(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 0.0),
                          padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                          child: Image.asset(
                            'assets/images/CovidFoodLogoBar.png',
                            fit: BoxFit.cover,
                          )),
                      new Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            'assets/images/CovidFoodLogo1.png',
                            width: 200.0,
                            height: 200.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            14.0, 8.0, 14.0, 8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.pinkAccent,
                          elevation: 0.0,
                          child: new MaterialButton(
                              minWidth: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment(-1,0),
                                    width: 80,
                                    child: new Icon(Icons.store_mall_directory,
                                      color: Colors.yellow,),
                                  ),
                                  Container(
                                    alignment: Alignment(0,0),
                                    child: new Text("เข้าระบบร้านค้า",
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 20.0,
                                          fontFamily: 'Kanit',
                                        )),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                globals.typeUser = "2";
                                gotoLoginApp();
                              }
                            //gotoWebView();
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            14.0, 8.0, 14.0, 8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.cyan,
                          elevation: 0.0,
                          child: new MaterialButton(

                              minWidth: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Row(

                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            alignment: Alignment(-1, 0),
                                            width: 80,
                                            child: new Icon(Icons.fastfood,
                                              color: Colors.yellow,
                                            )),
                                        Container(
                                          alignment: Alignment(0, 0),
                                          child: new Text(
                                            "เข้าระบบผู้สั่งอาหาร",
                                            style: new TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 20.0,
                                              fontFamily: 'Kanit',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              onPressed: () {
                                globals.typeUser = "1";
                                gotoLoginApp();
                              }),
                        ),
                      ),
                    ]))));
  }
}
