import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/authenticate/forgot_password.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/screens/authenticate/signup.dart';
import 'package:frontend/services/authenticate_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthenticateService service = AuthenticateService();
  APIResponse<User> _apiResponse;
  bool isLoading = false;

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 55,
            width: 55,
            child: CircularProgressIndicator()
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  login() async {
    showLoaderDialog(context);
    // await Future.delayed(Duration(seconds: 3));

    _apiResponse = await service.login(email, password);

    if (_apiResponse.error){
      setState(() {
        error = _apiResponse.errorMessage;
      });
      Navigator.pop(context);
    }
    else {
      if (_rememberme) {
        User user = _apiResponse.data;

        await updateShredPrefs(
            user.name, user.email, user.phoneNo, user.userID);
      }
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BottomNav()));

    }
  }

  Future<void> updateShredPrefs(
      String name, String email, String phone, int userID) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefConstants.email, email);
    await prefs.setString(PrefConstants.name, name);
    await prefs.setString(PrefConstants.phone, phone);
    await prefs.setInt(PrefConstants.id, userID);
  }

  String error = "";

  bool _obscureText = true;
  bool _rememberme = false;

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  String verifyEmail(String val){
    if(val.isEmpty)
      return 'Enter your Email or Phone number';
    else if(double.tryParse(val) != null){
      if(val.length != 10)
        return 'Enter a valid Phone number';  
    }
    else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val))
      return 'Enter a valid Email Address';
    else
      return null;  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/login_bottom.png',
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Text(
                    'Sign in to your account.',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  TextFormField(
                    validator: (val) => verifyEmail(val),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    cursorColor: MyColors.PrimaryColor,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      hintText: 'Email / Phone Number',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Visibility(
                          visible: true,
                          child: Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                            size: 17,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.white, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.white, width: 1.0)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.red, width: 1.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.red, width: 1.0)),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter a Password' : null,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    cursorColor: MyColors.PrimaryColor,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      hintText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Visibility(
                        visible: true,
                        child: Icon(
                          Icons.lock_outlined,
                          color: Colors.grey,
                          size: 17,
                        ),
                      ),
                      suffixIcon: Visibility(
                        visible: true,
                        child: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 17,
                          ),
                          color: Colors.grey,
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.white, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.white, width: 1.0)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.red, width: 1.0)),
                      focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.red, width: 1.0)),    
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              value: _rememberme,
                              onChanged: (value) {
                                setState(() {
                                  _rememberme = value;
                                });
                              },
                              activeColor: MyColors.SecondaryColor,
                            ),
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12),
                          )
                        ],
                      ),
                      TextButton(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: MyColors.SecondaryColor),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()));
                        },
                      )
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  SubmitButton(
                    text: 'Login',
                    onPress: () {
                      if (_formKey.currentState.validate())
                        login();
                    },
                  ),

                  //SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Signup()));
                        },
                        child: Text(
                          'Signup',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
