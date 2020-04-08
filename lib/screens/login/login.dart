import 'package:emenu_covid/screens/home/FirstPage2.dart';
import 'package:emenu_covid/screens/home/mainLocation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:emenu_covid/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emenu_covid/services/authService.dart';
import 'package:validators/validators.dart';
import 'package:emenu_covid/models/login.dart';
import 'package:emenu_covid/screens/Json/foods.dart';
import 'package:emenu_covid/models/register.dart';
import 'package:emenu_covid/globals.dart' as globals;
import 'package:emenu_covid/screens/login/signup.dart';
final User _user = new User();
final String DISPLAYNAME = "displayName";
final String IMAGEPATH = "imagePath";
final String EMAIL = 'email';
final String USERID = "userid";
final String TEL = "tel";
final String LASTNAME = "lastname";
final String IS_LOGIN = "is_login";



void main() => runApp(Login());

class Login extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<Login> {
  AuthService authService = AuthService();
  RetLogin _letLogin;


  String _locationMessage = "";

  void _getCurrentLocation() async {

    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
      globals.latitude = "${position.latitude}";
      globals.longtitude = "${position.longitude}";

    });

  }

  static final TextEditingController _textEmail = TextEditingController();

  String email;
  String password;

  final _formKey = GlobalKey<FormState>();
  bool hidePass = true;
  bool _result = false;
  FocusNode passwordFocusNode = FocusNode();



  @override
  Widget build(BuildContext context) {
    void _showAlertDialog({String strError}) async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(strError),
              content: Text("Please try again."),
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

    void SendtoJsonLogin({String email, String password, String type_}) async {

      String strBody =
          '{"email":"${email}","password":"${password}","type":"${type_}"}';
      var feed = await NetworkFoods.login(strBody: strBody);
      var data = DataFeed(feed: feed);

      if (data.feed.ResultOk.toString() == "true") {
        SharedPreferences _pref = await SharedPreferences.getInstance();
        _pref.setString(EMAIL, data.feed.email.toString());
        _pref.setString(DISPLAYNAME, data.feed.userName.toString());
        _pref.setString(USERID, data.feed.memberID.toString());
        _pref.setBool(IS_LOGIN, true);
        _pref.setString(TEL, data.feed.tel.toString());
        _pref.setString(LASTNAME, data.feed.lastname.toString());
        onLoginStatusChanged(true);
        globals.userID = feed.memberID.toString();
        globals.tel = feed.tel.toString();
        globals.lastName = feed.lastname.toString();
        globals.fullName = feed.userName.toString();

        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new FirstPage2()));
      } else {
        _showAlertDialog(strError: data.feed.ErrorMessage.toString());
      }
    }

    void SendtoJsonReg({String email, String password, String username}) async {
      String strBody =
          '{"email":"${email}","password":"${password}","username":"${username}"}';
      var feed = await NetworkFoods.insertRegister(strBody: strBody);
      var data = DataFeedReg(feed: feed);
      if (data.feed.ResultOk.toString() == "true") {
        //   globals.userID = feed..toString();

      } else {}
    }


    void _submit() async {
      if (this._formKey.currentState.validate()) {
        _formKey.currentState.save();
        SharedPreferences _pref = await SharedPreferences.getInstance();
        _getCurrentLocation();
        SendtoJsonLogin(email: email, password: password, type_: "N");
      }
    }

    double height = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120.0,
//                height: 240.0,
                  )),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Center(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.withOpacity(0.2),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  title: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      icon: Icon(Icons.alternate_email),
                                    ),
                                    validator: _validateEmail,
                                    controller: _textEmail,
                                    onSaved: (String value) {
                                      email = value;
                                    },
                                    onFieldSubmitted: (String value) {
                                      FocusScope.of(context)
                                          .requestFocus(passwordFocusNode);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.withOpacity(0.2),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  title: TextFormField(
                                    //  controller: _passwordTextController,
                                    focusNode: passwordFocusNode,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      icon: Icon(Icons.lock_outline),
                                    ),
                                    obscureText: hidePass,
                                    validator: _validatePassword,
                                    onSaved: (String value) {
                                      password = value;
                                    },
                                    onFieldSubmitted: (String value) {},
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
                            padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                            child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.green,
                                elevation: 0.0,
                                child: MaterialButton(
                                  onPressed: _submit,
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: Text(
                                    'Login',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Forgot password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignUp(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Create an account",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black),
                                      ))),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Or",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    14.0, 8.0, 14.0, 8.0),
                                child: Material(
                                  child: MaterialButton(
//                                    onPressed: () =>
//                                        initiateFacebookLogin(context),
                                    child: Image.asset(
                                      "assets/images/fb.png",
                                      width: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    14.0, 8.0, 14.0, 8.0),
                                child: Material(
                                    child: MaterialButton(
                                        onPressed: () {},
                                        // .then((FirebaseUser user) =>
                                        //   print(user))
                                        //  .catchError((e) => print(e)),
                                        child: Image.asset(
                                          "assets/images/ggg.png",
                                          width: 60,
                                        ))),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            ),
            /*    Visibility(
            //  visible: loading ?? true,
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
          ],
        ),
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
}



bool isLoggedIn = false;

void onLoginStatusChanged(bool isLoggedIn) {
  isLoggedIn = isLoggedIn;
}

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);

  final String providerDetails;
}

class DataFeed {
  RetLogin feed;

  DataFeed({this.feed});
}

class DataFeedReg {
  RetRegister feed;

  DataFeedReg({this.feed});
}
