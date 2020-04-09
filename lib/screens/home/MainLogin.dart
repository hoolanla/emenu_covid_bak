import 'package:flutter/material.dart';
import 'package:emenu_covid/screens/home/webView.dart';
import 'package:emenu_covid/screens/login/login.dart';

void main() {
  runApp(new MaterialApp(home: new MainLogin()));
}

class MainLogin extends StatefulWidget {
  @override
  MainLoginState createState() => new MainLoginState();
}

class MainLoginState extends State<MainLogin> {
  int counter = 0;
  List<String> strings = ["Flutter", "Is", "Awesome"];
  String displayedString = "";

  void onPressed() {
    setState(() {
      displayedString = strings[counter];
      counter = counter < 2 ? counter + 1 : 0;
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
