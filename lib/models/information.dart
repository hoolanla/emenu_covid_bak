class Information {
  String ResultOk;
  String ErrorMessage;
  String title;
  String desc;
  String openTime;
  Information({this.ResultOk,this.ErrorMessage,this.title, this.desc, this.openTime,});
  factory Information.fromJson(Map<String, dynamic> parsedJson) {
    return Information(
      ResultOk: parsedJson['ResultOk'],
      ErrorMessage: parsedJson['ErrorMessage'],
      title: parsedJson['title'],
      desc : parsedJson['desc'],
      openTime: parsedJson['openTime'],
    );
  }
}