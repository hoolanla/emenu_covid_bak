
class RetProfile{
  String ResultOk;
  String ErrorMessage;
  String Name;
  String Lastname;
  String Tel;
  String Email;
  String UserID;
  RetProfile ({
    this.ResultOk,
    this.ErrorMessage,
    this.Name,
    this.Lastname,
    this.Tel,
    this.Email,
    this.UserID,

  });
  factory RetProfile.fromJson(Map<String, dynamic> parsedJson){
    return RetProfile(
      ResultOk: parsedJson['ResultOk'],
      ErrorMessage: parsedJson['ErrorMessage'],
      Name: parsedJson['Name'],
      Lastname: parsedJson['Lastname'],
      Tel: parsedJson['Tel'],
      Email: parsedJson['Email'],
      UserID: parsedJson['UserID'],
    );
  }
}