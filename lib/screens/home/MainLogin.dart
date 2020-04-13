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
  //  print(position);
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
        appBar: new AppBar(
            title: new Text(
              "Covid Food",
              style: TextStyle(
                fontFamily: 'Kanit',
              ),
            ),
            backgroundColor: Colors.green),
        body: new Container(
            child: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 120.0,
//                height: 240.0,
                    )),
              ),
              new Text(displayedString,
                  style: new TextStyle(
                      fontSize: 30.0, fontWeight: FontWeight.bold)),
              new Padding(padding: new EdgeInsets.all(10.0)),
              new RaisedButton(
                  child: new Text("เข้าระบบร้านค้า",
                      style: new TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0,
                        fontFamily: 'Kanit',
                      )),
                  color: Colors.green,
                  onPressed: () => gotoWebView()),
              new Text(displayedString,
                  style: new TextStyle(
                      fontSize: 30.0, fontWeight: FontWeight.bold)),
              new Padding(padding: new EdgeInsets.all(10.0)),
              new RaisedButton(
                  child: new Text(
                    "เข้าระบบผู้สั่งอาหาร",
                    style: new TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0,
                      fontFamily: 'Kanit',
                    ),
                  ),
                  color: Colors.green,
                  onPressed: () => gotoLoginApp()),
            ]))));
  }
}
