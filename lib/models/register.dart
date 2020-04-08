
class Register{
  String username;
  String email;
  String password;
}



class RetRegister{
  String ResultOk;
  String ErrorMessage;
  String ReturnMessage;
  RetRegister ({
    this.ResultOk,
    this.ErrorMessage,
    this.ReturnMessage,
  });
  factory RetRegister.fromJson(Map<String, dynamic> parsedJson){
    return RetRegister(
      ResultOk: parsedJson['ResultOk'],
      ErrorMessage: parsedJson['ErrorMessage'],
      ReturnMessage: parsedJson['ReturnMessage'],
    );
  }
}

