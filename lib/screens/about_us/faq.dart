import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/services/about_us_service.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  AboutUsService service = AboutUsService();
  APIResponse<String> _apiResponse;
  String abtUs = "";
  bool isLoading = true;

  getAboutUs() async {
    _apiResponse = await service.faq();
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
          'FAQ',
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