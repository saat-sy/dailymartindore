import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/services/about_us_service.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  
  AboutUsService service = AboutUsService();
  APIResponse<String> _apiResponse;
  String abtUs = "";
  bool isLoading = true;

  getAboutUs() async {
    _apiResponse = await service.terms();
    if (!_apiResponse.error)
      if (mounted)
        setState(() {
          abtUs = _apiResponse.data;
          isLoading = false;
        });
    else
      print(_apiResponse.errorMessage);
  }

  @override
  void initState() {
    getAboutUs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(abtUs),
              ),
            ),
    );
  }
}