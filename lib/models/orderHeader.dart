class OrderHeader {
  String orderID;
  String qty;
  String totalPrice;
  String restaurant_name;
  String status;
  String createDate;
  OrderHeader({this.orderID, this.qty, this.totalPrice, this.restaurant_name, this.status,this.createDate});
  factory OrderHeader.fromJson(Map<String, dynamic> parsedJson) {
    return OrderHeader(
      orderID: parsedJson['orderID'],
      qty: parsedJson['qty'],
      totalPrice: parsedJson['totalPrice'],
      restaurant_name: parsedJson['restaurant_name'],
      status: parsedJson['status'],
      createDate: parsedJson['createDate'],
    );
  }
}

class ResultOrderHeader {
  String ResultOk;
  String ErrorMessage;
  String restuarantID;
  List<OrderHeader> orderHeaderList;

  ResultOrderHeader(
      {this.ResultOk,
        this.ErrorMessage,
        this.restuarantID,
        this.orderHeaderList
      });

  factory ResultOrderHeader.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['orderHeaderList'] as List;
    List<OrderHeader> orderHeaderList =
    list.map((i) => OrderHeader.fromJson(i)).toList();

    return ResultOrderHeader(
        ResultOk: parsedJson['ResultOk'],
        ErrorMessage: parsedJson['ErrorMessage'],
        restuarantID: parsedJson['restaurantID'],
        orderHeaderList: orderHeaderList);
  }
}