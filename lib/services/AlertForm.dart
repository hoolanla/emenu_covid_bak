import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


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

showAlert(BuildContext context) {
  Alert(
    context: context,
    type: AlertType.none,
    title: "Are you sure ?",
    desc: "คุณต้องการออกจาก Application ใช่ไหม?",
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
            Navigator.of(context, rootNavigator: true).pop();
          }),
      DialogButton(
        child: Text(
          "EXIT",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Kanit',
          ),
        ),
        onPressed: () {
            exit(0);

          //  Navigator.of(context, rootNavigator: true).pop();
        },
        color: Colors.red,
      )
    ],
  ).show();
}