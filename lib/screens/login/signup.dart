
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';
import 'package:emenu_covid/models/register.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/services/AlertForm.dart';


class SignUp extends StatefulWidget {
  final String userName;
  final String telephone;

  SignUp({
    this.userName,
    this.telephone,
  });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  static final TextEditingController _textFullName = TextEditingController();
  static final TextEditingController _textTel = TextEditingController();

  Register _reg;
  String username;
  String tel;
  String password;

  String gender;
  String groupValue = "male";
  bool hidePass = true;
  bool loading = false;
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode telFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    void _showAlertDialogComplete({String strReturn,String strContent}) async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(strReturn),
              content: Text(strContent),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context, new MaterialPageRoute(builder: (context) => null));
                  },
                  child: Text("OK"),
                )
              ],
            );
          });
    }

    void _showAlertDialogNotComplete({String strReturn,String strContent}) async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(strReturn),
              content: Text(strContent),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                )
              ],
            );
          });
    }


    void SendtoJson({String tel, String password, String username}) async {



      String strBody =
          '{"tel":"${tel}","password":"${password}","username":"${username}","type":"${globals.typeUser}"}';
      var feed = await NetworkFoods.insertRegister(strBody: strBody);
      var data = DataFeed(feed: feed);

      if (data.feed.ResultOk == "true") {

        globals.userID = data.feed.ReturnMessage;
        AlertService tmp = new AlertService(title: 'ลงทะเบียนสำเร็จ',desc: '');
        tmp.showAlertRegisSuccess(context);
      } else {
        AlertService tmp = new AlertService(title: 'ลงทะเบียนไม่สำเร็จ',desc: data.feed.ErrorMessage.toString());
        tmp.showAlertRegisSuccessFalse(context);
      //  showAlertRegisSuccessFalse(context);
      //  _showAlertDialogNotComplete(strReturn: data.feed.ErrorMessage,strContent: 'Please try again.');
      }
    }

    void _submit() async {
      if (this._formKey.currentState.validate()) {
        _formKey.currentState.save();
        //todo
        SendtoJson(tel: tel, password: password, username: username);
      }
    }

//    _textFullName.text = globals.fullName;
//    _textTel.text = globals.emailFB;

    return Scaffold(

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(left: 0.0, right: 0.0,top: 0.0),
                  padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                  child: Image.asset(
                    'assets/images/CovidFoodLogoBar.png',
                    fit: BoxFit.cover,
//                height: 240.0,
                  )),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/images/CovidFoodLogo1.png',
                      width: 120.0,
//                height: 240.0,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.withOpacity(0.2),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: ListTile(
                      title: TextFormField(
                        controller: _textFullName,
                        decoration: InputDecoration(
                            hintText: "Full name",
                            icon: Icon(Icons.person_outline),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "The name field cannot be empty";
                          }
                        },
                        onSaved: (String value) {
                          username = value;
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(telFocusNode);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.withOpacity(0.2),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: ListTile(
                      title: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        controller: _textTel,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Telephone",
                            icon: Icon(Icons.phone),
                            border: InputBorder.none),
                        validator: _validateTel,
                        onSaved: (String value) {
                          tel = value;
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context)
                              .requestFocus(passwordFocusNode);
                        },
                        focusNode: telFocusNode,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.withOpacity(0.2),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: ListTile(
                      title: TextFormField(
                        obscureText: hidePass,
                        decoration: InputDecoration(
                            hintText: "Password",
                            icon: Icon(Icons.lock_outline),
                            border: InputBorder.none),
                        validator: _validatePassword,
                        onSaved: (String value) {
                          password = value;
                        },
                        focusNode: passwordFocusNode,
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              hidePass = !hidePass;
                            });
                          }),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.pinkAccent,
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: _submit,
                      minWidth: MediaQuery.of(context).size.width,
                      child: Text(
                        'Sign up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "I already have an account",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ))),
            ],
          ),
        ),

        /*      Visibility(
            visible: loading ?? true,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ),
          )*/
      ),
    );
  }

  String _validateTel(String value) {
    if (value.isEmpty) {
      return "Telphone is empty.";
    }

    if (!isNumeric(value)) {
      return "Telphone must numeric.";
    }

    if (!isLength(value,10,10)) {
      return "Telphone must Length 10 charactors.";
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 6) {
      return "Password must 6 charactors.";
    }
    return null;
  }

  String _validateName(String value) {
    if (value.isEmpty) {
      return "Name is empty.";
    }
    return null;
  }
}

class DataFeed {
  RetRegister feed;

  DataFeed({this.feed});
}
