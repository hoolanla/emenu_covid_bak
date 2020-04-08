
class Bill{
  String restaurantID;
  String tableID;
  String userID;
}


class RetBill{
  String ResultOk;
  String ErrorMessage;
  String ReturnMessage;
  RetBill ({
    this.ResultOk,
    this.ErrorMessage,
    this.ReturnMessage,
  });
  factory RetBill.fromJson(Map<String, dynamic> parsedJson){
    return RetBill(
      ResultOk: parsedJson['ResultOk'],
      ErrorMessage: parsedJson['ErrorMessage'],
      ReturnMessage: parsedJson['ReturnMessage'],
    );
  }
}
