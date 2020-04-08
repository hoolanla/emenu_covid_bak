
class LogoutTable {
  String ResultOk;
  String ErrorMessage;
  String ReturnMessage;

  LogoutTable({
    this.ResultOk,
    this.ErrorMessage,
    this.ReturnMessage,
  });

  factory LogoutTable.fromJson(Map<String, dynamic> parsedJson) {
    return LogoutTable(
      ResultOk: parsedJson['ResultOk'],
      ErrorMessage: parsedJson['ErrorMessage'],
      ReturnMessage: parsedJson['ReturnMessage'],
    );
  }
}