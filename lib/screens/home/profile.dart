
import 'package:flutter/material.dart';
import 'package:emenu_covid/models/profile.dart';
import 'package:validators/validators.dart';
import 'package:emenu_covid/models/register.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/screens/home/FirstPage.dart';

class Profile extends StatefulWidget {
  final String userName;
  final String email;

  Profile({
    this.userName,
    this.email,
  });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  static final TextEditingController _textFullName = TextEditingController();
  static final TextEditingController _textEmail = TextEditingController();
  static final TextEditingController _textLastname = TextEditingController();
  static final TextEditingController _textTel = TextEditingController();

  Register _reg;
  String name;
  String lastname;
  String tel;

  String gender;
  String groupValue = "male";
  bool hidePass = true;
  bool loading = false;
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();

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
                        context, new MaterialPageRoute(builder: (context) => new FirstPage()));
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


    void SendtoJson({String name, String lastname, String tel}) async {
      String strBody =
          '{"Name":"${name}","Lastname":"${lastname}","Tel":"${tel}","UserID":"${globals.userID}"}';
      var feed = await NetworkFoods.updateProfile(strBody: strBody);
      var data = DataFeed(feed: feed);

      if (data.feed.ResultOk == "true") {

        globals.tel = data.feed.Tel;
        globals.lastName = data.feed.Lastname;
        globals.fullName = data.feed.Name;
        _showAlertDialogComplete(strReturn: 'Update profile success. ',strContent: 'Thank you');
      } else {
        _showAlertDialogNotComplete(strReturn: data.feed.ErrorMessage,strContent: 'Please try again.');
      }
    }

    void _submit() async {
      if (this._formKey.currentState.validate()) {
        _formKey.currentState.save();
        //todo
        SendtoJson(name: name, lastname: lastname, tel: tel);
      }
    }

    _textFullName.text = globals.fullName;
    _textEmail.text = globals.emailFB;
    _textLastname.text = globals.lastName;
    _textTel.text = globals.tel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          'Edit profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 100, 20, 10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                            labelText: "Name",
                            hintText: "Full name",
                            icon: Icon(Icons.person_outline),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "The name field cannot be empty";
                          }
                        },
                        onSaved: (String value) {
                          name = value;
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(emailFocusNode);
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
                        controller: _textLastname,
                        decoration: InputDecoration(
                            labelText: "Lastname",
                            hintText: "Lastname",
                            icon: Icon(Icons.alternate_email),
                            border: InputBorder.none),
                        // validator: _validateEmail,
                        onSaved: (String value) {
                          lastname = value;
                        },
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context)
                              .requestFocus(passwordFocusNode);
                        },
                        focusNode: emailFocusNode,
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
                        controller: _textTel,
                        decoration: InputDecoration(
                            labelText: "Tel",
                            hintText: "Tel",
                            icon: Icon(Icons.settings_cell),
                            border: InputBorder.none),
                        onSaved: (String value) {
                          tel = value;
                        },
                        focusNode: passwordFocusNode,
                      ),
//                      trailing: IconButton(
//                          icon: Icon(Icons.remove_red_eye),
//                          onPressed: () {
//                            setState(() {
//                              hidePass = !hidePass;
//                            });
//                          }),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green,
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: _submit,
                      minWidth: MediaQuery.of(context).size.width,
                      child: Text(
                        'Update profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    )),
              ),

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

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return "Email is empty.";
    }
    if (!isEmail(value)) {
      return "Email must must be valid email pattern.";
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
  RetProfile feed;

  DataFeed({this.feed});
}



