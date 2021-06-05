import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/services/authenticate_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  AuthenticateService service = AuthenticateService();
  APIResponse<bool> _apiResponse;
  String error = '';

  bool _obscure1 = false;
  bool _obscure2 = false;
  bool _obscure3 = false;

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

  submit() async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponse = await service.changePassword(
        password: newPass.text,
        cpassword: cnewPass.text,
        opassword: oldPass.text,
        userID: id);
    if (_apiResponse.error) {
      print(_apiResponse.errorMessage);
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
        });
      Navigator.pop(context);
    } else {
      final snackBar =
          SnackBar(content: Text("Password changed successfully!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final cnewPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Change Password'),
            centerTitle: true),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('Change your Password',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: oldPass,
                      obscureText: _obscure1,
                      validator: (val) =>
                          val.isEmpty ? 'Enter your old Password' : null,
                      cursorColor: MyColors.PrimaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 10.0),
                        hintText: 'Old Password',
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
                              _obscure1
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 17,
                            ),
                            color: Colors.grey,
                            onPressed: () {
                              if (mounted)
                                setState(() {
                                  _obscure1 = !_obscure1;
                                });
                            },
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200, width: 1.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                                color: MyColors.PrimaryColor, width: 1.0)),
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
                    SizedBox(height: 20),
                    TextFormField(
                      controller: newPass,
                      validator: (val) =>
                          val.isEmpty ? 'Enter the new Password' : null,
                      cursorColor: MyColors.PrimaryColor,
                      obscureText: _obscure2,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 10.0),
                        hintText: 'New Password',
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
                              _obscure2
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 17,
                            ),
                            color: Colors.grey,
                            onPressed: () {
                              if (mounted)
                                setState(() {
                                  _obscure2 = !_obscure2;
                                });
                            },
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200, width: 1.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                                color: MyColors.PrimaryColor, width: 1.0)),
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
                    SizedBox(height: 20),
                    TextFormField(
                      controller: cnewPass,
                      validator: (val) =>
                          val.isEmpty ? 'Retype new Password' : null,
                      cursorColor: MyColors.PrimaryColor,
                      obscureText: _obscure3,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 10.0),
                        hintText: 'Retype new Password',
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
                              _obscure3
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 17,
                            ),
                            color: Colors.grey,
                            onPressed: () {
                              if (mounted)
                                setState(() {
                                  _obscure3 = !_obscure3;
                                });
                            },
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200, width: 1.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                                color: MyColors.PrimaryColor, width: 1.0)),
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
                    SizedBox(height: 12),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 12),
                    SubmitButton(
                      text: 'Submit',
                      onPress: () {
                        submit();
                      },
                    )
                  ],
                ),
              )),
        ));
  }
}
