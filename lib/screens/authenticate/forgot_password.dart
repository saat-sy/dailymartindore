import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/stylesheet/styles.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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

  String email = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Forgot Password'),
            centerTitle: true),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image(image: AssetImage('assets/images/forgot_password.png')),
                SizedBox(height: 10),
                Text('Forgot your Password?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 5),
                Text('Enter your email here',
                  style: TextStyle(fontSize: 15)
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Enter your name' : null,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  cursorColor: MyColors.PrimaryColor,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    hintText: 'Email',
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
                        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: MyColors.PrimaryColor, width: 1.0)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.red, width: 1.0)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.red, width: 1.0)),
                  ),
                ),
                SizedBox(height: 25),
                SubmitButton(
                  text: 'Submit'
                )
              ],
            ),
          )),
        ));
  }
}
