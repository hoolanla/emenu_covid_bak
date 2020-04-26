import 'package:flutter/material.dart';
import 'package:emenu_covid/globals.dart' as globals;

class QRcode extends StatefulWidget {
  QRcode({Key key}) : super(key: key);

  @override
  _QRState createState() => _QRState();
}

class _QRState extends State<QRcode> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR CODE'),
        backgroundColor: Colors.cyan,
        
      ),
      body: Container(
        alignment: Alignment.center,
        child: Card(

          child: Image.network('http://103.82.248.128/eMenu/QRCoderestaurantID/' + globals.restaurantID + '.png'),

        ),
      ),
    );
  }


}