import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/authenticate/getting_started.dart';
import 'package:frontend/services/authenticate_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class VerifyOTP extends StatefulWidget {
  final String email;
  final int otp;
  final String phone;

  VerifyOTP({this.email, this.otp, this.phone});

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  AuthenticateService service = AuthenticateService();
  APIResponse<User> _apiResponse;
  bool isLoading = false;

  String error = "";

  String otp_send_status = 'Resend OTP';

  int userEnteredOTP = 0;

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

  verifyOTP() async {
    showLoaderDialog(context);
    // await Future.delayed(Duration(seconds: 3));

    _apiResponse = await service.verifyOTP(widget.email, userEnteredOTP);

    if (_apiResponse.error){
      setState(() {
        error = _apiResponse.errorMessage;
      });
      Navigator.pop(context);
    }
    else {
      User user = _apiResponse.data;

      await updateShredPrefs(user.name, user.email, user.phoneNo, user.userID);
      
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GettingStarted()));
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

  resendOTP() async {
    setState(() {
      otp_send_status = 'Sending new OTP';
    });

    _apiResponse = await service.resendOTP(widget.phone);

    if (_apiResponse.error)
      setState(() {
        error = _apiResponse.errorMessage;
        otp_send_status = 'Failed to resend OTP';
      });
    else {
      setState(() {
        otp_send_status = 'New OTP sent';
      });
    }
  }

  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: MyColors.PrimaryColor,
        width: 1,
      ),
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/images/otp.png'),
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Verify OTP',
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
            'You will get an OTP via SMS',
            style: TextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
                fontSize: 15),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              withCursor: true,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              onSubmit: (String pin) {
                userEnteredOTP = int.parse(pin);
              },
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
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
            width: MediaQuery.of(context).size.width * 0.8,
            text: 'Verify',
            onPress: () {
              if (userEnteredOTP != 0) {
                verifyOTP();
              } else {
                setState(() {
                  error = 'Please enter the OTP';
                });
              }
            },
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Didn\'t recieve the code?',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              resendOTP();
            },
            child: Container(
              child: Text(
                otp_send_status,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MyColors.SecondaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
