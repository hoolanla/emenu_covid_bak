import 'dart:async' show Future;
import 'dart:convert';
import 'package:emenu_covid/models/foods.dart';
import 'package:emenu_covid/models/order.dart';
import 'package:emenu_covid/models/login.dart';
import 'package:emenu_covid/models/profile.dart';
import 'package:emenu_covid/models/register.dart';
import 'package:emenu_covid/models/bill.dart';
import 'package:emenu_covid/models/restaurant.dart';
import 'package:emenu_covid/models/history.dart';
import 'package:emenu_covid/models/logout.dart';
import 'package:emenu_covid/models/orderHeader.dart';
import 'package:emenu_covid/models/orderDetail.dart';
import 'package:http/http.dart' as http;
import 'package:emenu_covid/globals.dart' as globals;

class NetworkFoods {
  static Future<Menu> loadFoodsAsset(
      {String RestaurantID, String Recommend}) async {
//
//      String jsonPage = await  rootBundle.loadString('assets/foods2.json');
//    final jsonResponse = json.decode(jsonPage);
//    Menu _menu = new Menu.fromJson(jsonResponse);
//    return _menu;

    final String restaurantID = globals.restaurantID;
    final String tableID = globals.tableID;
    final String userID = globals.userID;
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/DelGeteMenu';
    String body =
        '{"restaurantID":"${RestaurantID}","recommend":"${Recommend}"}';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: body);
    final jsonResponse = json.decode(response.body.toString());
    Menu _menu = new Menu.fromJson(jsonResponse);
    return _menu;
  }

  static Future<Restaurant> loadRestaurant() async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/DelGetFirstPage';
    String Strbody = '{"restaurantID":"","Latitude":"${globals.latitude}","Longtitude":"${globals.longtitude}"}';

    print(Strbody);
    var response = await http.post(
      '$url',
      headers: {"Content-Type": "application/json"},
      body: Strbody,
    );
    final jsonResponse = json.decode(response.body.toString());
    Restaurant _restaurant = new Restaurant.fromJson(jsonResponse);
    return _restaurant;
  }

  static Future<LogoutTable> loadLogout(String strBody) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/Logout';
    var response = await http.post(
      '$url',
      headers: {"Content-Type": "application/json"},
      body: strBody,
    );
    final jsonResponse = json.decode(response.body.toString());
    LogoutTable _logout = new LogoutTable.fromJson(jsonResponse);
    return _logout;
  }

  static Future<retCheckBillStatus> loadRetCheckBillStatus(String strBody) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/getStatusOrderIsBillPlease';
    var response = await http.post(
      '$url',
      headers: {"Content-Type": "application/json"},
      body: strBody,
    );
    final jsonResponse = json.decode(response.body.toString());
    retCheckBillStatus _ret = new retCheckBillStatus.fromJson(jsonResponse);
    return _ret;
  }

  static Future<Restaurant> loadRestaurantByID({String strBody}) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/getFirstPageByID';
    String body = '';
    var response = await http.post(
      '$url',
      headers: {"Content-Type": "application/json"},
      body: strBody,
    );
    final jsonResponse = json.decode(response.body.toString());
    Restaurant _restaurant = new Restaurant.fromJson(jsonResponse);
    return _restaurant;
  }

  static Future<StatusOrder> loadStatusOrder(String strBody) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/getOrder';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    if (jsonResponse.toString().contains('false')) {}
    StatusOrder _statusOrder = new StatusOrder.fromJson(jsonResponse);
    return _statusOrder;
  }


  static Future<double> loadTotalOrderHeader(String strBody) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/DelGetOrderHeaderByUserID';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    ResultOrderHeader _totals = new ResultOrderHeader.fromJson(jsonResponse);
    double total = 0;
    if(_totals.ResultOk ==  "true")
    {
      for (int i = 0; i < _totals.orderHeaderList.length; i++) {
        total += double.parse(_totals.orderHeaderList[i].totalPrice);
      }
      return total;
    }
    else
    {
      return 0;
    }
  }


  static Future<ResultOrderHeader> loadOrderHeader(String strBody) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/DelGetOrderHeaderByUserID';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    if (jsonResponse.toString().contains('false')) {}
    ResultOrderHeader _ResultOrderHeader = new ResultOrderHeader.fromJson(jsonResponse);
    return _ResultOrderHeader;
  }

  static Future<double> loadTotalOrderDetail(String strBody) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/DelGetOrderDetail';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    ResultOrderDetail _totals = new ResultOrderDetail.fromJson(jsonResponse);
    double total = 0;
    if(_totals.orderList.length > 0)
    {
      for (int i = 0; i < _totals.orderList.length; i++) {
        total += double.parse(_totals.orderList[i].totalPrice);
      }
      return total;
    }
    else
    {
      return 0;
    }
  }
  static Future<ResultOrderDetail> loadOrderDetail(String strBody) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/DelGetOrderDetail';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    if (jsonResponse.toString().contains('false')) {}
    ResultOrderDetail _ResultOrderDetail = new ResultOrderDetail.fromJson(jsonResponse);
    return _ResultOrderDetail;
  }


  static Future<double> loadTotalStatusOrder(String strBody) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/getOrder';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    StatusOrder _totals = new StatusOrder.fromJson(jsonResponse);
    double total = 0;
    if(_totals.orderList.length > 0)
    {
      for (int i = 0; i < _totals.orderList.length; i++) {
        total += double.parse(_totals.orderList[i].totalPrice);
      }
      return total;
    }
    else
    {
      return 0;
    }
  }

  static Future<HistoryUser> loadHistory(String strBody) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/getHistoryUser';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    HistoryUser _history = new HistoryUser.fromJson(jsonResponse);
    return _history;
  }


  static Future<double> loadTotalHistory(String strBody) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/getHistoryUser';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    HistoryUser _history = new HistoryUser.fromJson(jsonResponse);
    double total = 0;
    if(_history.data.length > 0)
    {
      for (int i = 0; i < _history.data.length; i++) {
        total += _history.data[i].SumPrice;
      }
      return total;
    }
    else
    {
      return 0;
    }
  }

  static Future<RetStatusInsertOrder> inSertOrder({String strBody}) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/DelInsertOrder';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    RetStatusInsertOrder _retStatusInsertOrder =
    new RetStatusInsertOrder.fromJson(jsonResponse);
    return _retStatusInsertOrder;
  }

  static Future<RetRegister> insertRegister({String strBody}) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/register';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    RetRegister _retStatusReg = new RetRegister.fromJson(jsonResponse);
    return _retStatusReg;
  }


  static Future<RetProfile> updateProfile({String strBody}) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/updateProfile';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    RetProfile _retStatusProfile = new RetProfile.fromJson(jsonResponse);
    return _retStatusProfile;
  }

  static Future<RetLogin> login({String strBody}) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/login';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    RetLogin _ret = new RetLogin.fromJson(jsonResponse);
    return _ret;
  }

  static Future<RetBill> checkBill({String strBody}) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/noticeBillOrder';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    RetBill _ret = new RetBill.fromJson(jsonResponse);
    return _ret;
  }

  static Future<RetCancelOrder> cancelOrder({String strBody}) async {
    String url = 'http://103.82.248.128/eMenuAPI/api/eMenu/cancelOrder';
    var response = await http.post('$url',
        headers: {"Content-Type": "application/json"}, body: strBody);
    final jsonResponse = json.decode(response.body.toString());
    RetCancelOrder _ret = new RetCancelOrder.fromJson(jsonResponse);
    return _ret;
  }
}
