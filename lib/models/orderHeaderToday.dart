class OrderHeaderToday {
  String orderID;
  String qty;
  String totalPrice;
  String userName;
  String tel;
  String status;
  String distance;
  String createDate;
  OrderHeaderToday({this.orderID, this.qty, this.totalPrice, this.userName,this.tel, this.status,this.distance,this.createDate});
  factory OrderHeaderToday.fromJson(Map<String, dynamic> parsedJson) {
    return OrderHeaderToday(
      orderID: parsedJson['orderID'],
      qty: parsedJson['qty'],
      totalPrice: parsedJson['totalPrice'],
      userName: parsedJson['userName'],
      tel: parsedJson['tel'],
      status: parsedJson['status'],
      distance: parsedJson['distance'],
      createDate: parsedJson['createDate'],
    );
  }
}


class ResultOrderHeaderToday {
  String ResultOk;
  String ErrorMessage;
  List<OrderHeaderToday> orderHeaderTodayList;

  ResultOrderHeaderToday(
      {this.ResultOk,
        this.ErrorMessage,
        this.orderHeaderTodayList
      });

  factory ResultOrderHeaderToday.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['orderHeaderTodayList'] as List;
    List<OrderHeaderToday> orderHeaderTodayList =
    list.map((i) => OrderHeaderToday.fromJson(i)).toList();

    return ResultOrderHeaderToday(
        ResultOk: parsedJson['ResultOk'],
        ErrorMessage: parsedJson['ErrorMessage'],
        orderHeaderTodayList: orderHeaderTodayList);
  }
}
