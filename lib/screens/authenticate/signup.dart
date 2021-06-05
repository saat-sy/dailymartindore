import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/authenticate/signup_model.dart';
import 'package:frontend/screens/authenticate/login.dart';
import 'package:frontend/screens/authenticate/verify_otp.dart';
import 'package:frontend/services/authenticate_service.dart';
import 'package:frontend/stylesheet/styles.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  AuthenticateService service = AuthenticateService();
  APIResponse<SignUpModel> _apiResponse;
  String error = "";

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 55, width: 55, child: CircularProgressIndicator()),
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

  signup() async {
    showLoaderDialog(context);
    _apiResponse = await service.signup(SignUpInputModel(
        name: name,
        email: email,
        password: password,
        cpassword: cpassword,
        phoneNo: phoneNo));
    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
        });
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyOTP(
                  email: email, otp: _apiResponse.data.otp, phone: phoneNo)));
    }
  }

  bool _obscureText = true;
  bool _obscureTextConfirmPas = true;

  final _formKey = GlobalKey<FormState>();

  String name = '';
  String cpassword = '';
  String phoneNo = '';
  String email = '';
  String password = '';

  String verifyEmail(String val) {
    if (val.isEmpty)
      return 'Enter your Email';
    else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(val))
      return 'Enter a valid Email Address';
    else
      return null;
  }

  String verifyPhoneNo(String val) {
    if (val.isEmpty)
      return 'Enter your Phone number';
    else if (val.length != 10)
      return 'Enter a valid Phone number';
    else
      return null;
  }

  String verifyPassword(String val) {
    if (val.isEmpty)
      return 'Enter a Password';
    else if (val.length < 8)
      return 'Password must be atleast 8 characters long';
    else
      return null;
  }

  String verifyConfirmPassword(String val) {
    if (val.isEmpty)
      return 'Retype the Password';
    else if (val != password)
      return 'Passwords don\'t match';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Create Account!',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Quickly create account.',
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Enter your name' : null,
                        onChanged: (value) {
                          if (mounted)
                            setState(() {
                              name = value;
                            });
                        },
                        cursorColor: MyColors.PrimaryColor,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          hintText: 'Name',
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Visibility(
                              visible: true,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 17,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0)),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (val) => verifyEmail(val),
                        onChanged: (value) {
                          if (mounted)
                            setState(() {
                              email = value;
                            });
                        },
                        cursorColor: MyColors.PrimaryColor,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          hintText: 'Email Address',
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
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0)),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (val) => verifyPhoneNo(val),
                        onChanged: (value) {
                          if (mounted)
                            setState(() {
                              phoneNo = value;
                            });
                        },
                        cursorColor: MyColors.PrimaryColor,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          hintText: 'Phone',
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Visibility(
                              visible: true,
                              child: Icon(
                                Icons.phone_outlined,
                                color: Colors.grey,
                                size: 17,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0)),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (val) => verifyPassword(val),
                        onChanged: (value) {
                          if (mounted)
                            setState(() {
                              password = value;
                            });
                        },
                        cursorColor: MyColors.PrimaryColor,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
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
                                if (mounted)
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                              },
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (val) => verifyConfirmPassword(val),
                        onChanged: (value) {
                          if (mounted)
                            setState(() {
                              cpassword = value;
                            });
                        },
                        cursorColor: MyColors.PrimaryColor,
                        obscureText: _obscureTextConfirmPas,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          hintText: 'Confirm Password',
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
                                _obscureTextConfirmPas
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 17,
                              ),
                              color: Colors.grey,
                              onPressed: () {
                                if (mounted)
                                  setState(() {
                                    _obscureTextConfirmPas =
                                        !_obscureTextConfirmPas;
                                  });
                              },
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0)),
                        ),
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
                        text: 'Signup',
                        onPress: () {
                          if (_formKey.currentState.validate()) signup();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
