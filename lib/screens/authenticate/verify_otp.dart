import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
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
  APIResponse<User> _apiResponseResend;
  bool isLoading = false;

  String error = "";

  String otpSendStatus = 'Resend OTP';

  int userEnteredOTP = 0;

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

  verifyOTP() async {
    showLoaderDialog(context);
    // await Future.delayed(Duration(seconds: 3));

    _apiResponse = await service.verifyOTP(widget.email, userEnteredOTP);

    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
        });
      Navigator.pop(context);
    } else {
      User user = _apiResponse.data;

      await updateShredPrefs(user.name, user.email, user.phoneNo, user.userID);

      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => BottomNav(),
        ),
        (route) => false,
      );
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

  int time = 120;

  resendOTP() async {
    if (mounted)
      setState(() {
        otpSendStatus = 'Sending new OTP';
      });

    _apiResponseResend = await service.resendOTP(widget.phone);

    if (_apiResponseResend.error) if (mounted)
      setState(() {
        error = _apiResponseResend.errorMessage;
        otpSendStatus = 'Resend OTP';
        final snackBar = SnackBar(content: Text('Failed to send new OTP'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    else {
      if (mounted)
        setState(() {
          time = time * 2;
          _timerRunning = true;
          startTimer();
          final snackBar = SnackBar(content: Text('New OTP sent!'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
    }
  }

  bool _timerRunning = true;
  // ignore: unused_field
  Timer _timer;
  int _start;
  String timerData = "";

  void startTimer() {
    _start = time;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (mounted)
            setState(() {
              _timerRunning = false;
              timer.cancel();
            });
        } else {
          if (mounted)
            setState(() {
              _start--;
              int mins = (_start / 60).truncate();
              int seconds = _start - mins * 60;
              String minsString = (_start / 60).truncate().toString();
              String secondsString = (_start - mins * 60).toString();
              if (mins < 10) minsString = "0" + minsString;
              if (seconds < 10) secondsString = "0" + secondsString;
              timerData = "$minsString : $secondsString";
            });
        }
      },
    );
  }

  @override
  initState() {
    startTimer();
    super.initState();
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
              fontWeight: FontWeight.w400,
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
                if (mounted)
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
            'Didn\'t recieve the code? Resend OTP in:',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          SizedBox(
            height: 5,
          ),
          _timerRunning
              ? Text(
                  timerData,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: MyColors.SecondaryColor),
                )
              : InkWell(
                  onTap: () {
                    resendOTP();
                  },
                  child: Container(
                    child: Text(
                      otpSendStatus,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: MyColors.SecondaryColor),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
