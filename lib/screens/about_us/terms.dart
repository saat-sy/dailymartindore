import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/services/about_us_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
          : SingleChildScrollView(
              child: Html(
                data: abtUs,
                onLinkTap: (url) async {
                  if (await canLaunch(url))
                    await launch(url,
                      forceSafariVC: false,
                      forceWebView: false,
                    );
                  else {
                    final snackBar = SnackBar(content: Text('Could not launch the url'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
    );
  }
}