class OrderDetailToday {
  String orderID;
  String foodsID;
  String foodsName;
  String qty;
  String price;
  String totalPrice;

  OrderDetailToday({this.orderID, this.foodsID, this.foodsName, this.qty, this.price,this.totalPrice});

  factory OrderDetailToday.fromJson(Map<String, dynamic> parsedJson) {
    return OrderDetailToday(
      orderID: parsedJson['orderID'],
      foodsID: parsedJson['foodsID'],
      foodsName: parsedJson['foodsName'],
      qty: parsedJson['qty'],
      price: parsedJson['price'],
      totalPrice: parsedJson['totalPrice'],
    );
  }

}



class ResultOrderDetailToday {
  String ResultOk;
  String ErrorMessage;
  String orderID;
  String userID;
  List<OrderDetailToday> orderDetailTodayList;

  ResultOrderDetailToday(
      {this.ResultOk,
        this.ErrorMessage,
        this.orderID,
        this.userID,
        this.orderDetailTodayList
      });

  factory ResultOrderDetailToday.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['orderList'] as List;
    List<OrderDetailToday> orderDetailList = list.map((i) => OrderDetailToday.fromJson(i)).toList();

    return ResultOrderDetailToday(
        ResultOk: parsedJson['ResultOk'],
        ErrorMessage: parsedJson['ErrorMessage'],
        orderID: parsedJson['orderID'],
        userID: parsedJson['userID'],
        orderDetailTodayList: orderDetailList);
  }
}