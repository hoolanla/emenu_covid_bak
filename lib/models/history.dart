
class HistoryUser{
  List<Data> data;
  String ResultOk;
  String ErrorMessage;
  String userName;



  HistoryUser ({
    this.data,
    this.ResultOk,
    this.ErrorMessage,
    this.userName,

  });

  factory HistoryUser.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['data'] as List;
    List<Data> data = list.map((i) => Data.fromJson(i)).toList();

    return HistoryUser(
      data: data,
      ResultOk: parsedJson['ResultOk'],
      ErrorMessage: parsedJson['ErrorMessage'],
      userName: parsedJson['userName'],

    );
  }
}


class Data{
  String CategoryName;
  int CountOrder;
  double SumPrice;

  Data({
    this.CategoryName,
    this.CountOrder,
    this.SumPrice,
  });

  factory Data.fromJson(Map<String, dynamic> parsedJson){
    return Data(
      CategoryName: parsedJson['CategoryName'],
      CountOrder: int.parse(parsedJson['CountOrder']),
      SumPrice: double.parse(parsedJson['SumPrice']),
    );
  }

}

