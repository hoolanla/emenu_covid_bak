
import 'package:emenu_covid/models/orderDetailToday.dart';
import 'package:emenu_covid/screens/admin/OrderHeaderToday.dart';
import 'package:emenu_covid/screens/home/FirstPage.dart';
import 'package:emenu_covid/screens/home/MyOrder.dart';
import 'package:flutter/material.dart';
import 'package:emenu_covid/screens/login/login.dart';
import 'package:emenu_covid/screens/home/MainLogin.dart';
import 'package:emenu_covid/globals.dart';



main()  {
  runApp(new App());
}

class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}
class _AppState extends State<App> {

  final ThemeData androidTheme = new ThemeData(
      accentColor: Colors.black45,
      primaryColor: Colors.green);



  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'eMenu',
        theme: androidTheme,
        initialRoute: '/',
        routes: <String, Widget Function(BuildContext)>{
           '/': (context) => MainLogin(),
         '/MyOrder': (context) => MyOrder(),
          '/FirstPage': (context) => FirstPage(),
          '/Login': (context) => Login(),

//         '/': (context) => Login(),
        }
    );
  }
}




