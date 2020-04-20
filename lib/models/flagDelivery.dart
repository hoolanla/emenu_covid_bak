
class resultUpdateFlagDelivery {
  String ResultOk;
  String ErrorMessage;
  String ReturnMessage;

  resultUpdateFlagDelivery({
    this.ResultOk,
    this.ErrorMessage,
    this.ReturnMessage
  });

  factory resultUpdateFlagDelivery.fromJson(Map<String, dynamic> parsedJson) {
    return resultUpdateFlagDelivery(
        ResultOk: parsedJson['ResultOk'],
        ErrorMessage: parsedJson['ErrorMessage'],
        ReturnMessage:  parsedJson['ReturnMessage']);
  }
}