import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/services/about_us_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  AboutUsService service = AboutUsService();
  APIResponse<String> _apiResponse;
  String privacyPolicy = "";
  bool isLoading = true;

  getPrivacyPolicy() async {
    _apiResponse = await service.privacyPolicy();
    if (!_apiResponse.error) if (mounted)
      setState(() {
        privacyPolicy = _apiResponse.data;
        isLoading = false;
      });
    else
      print(_apiResponse.errorMessage);
  }

  @override
  void initState() {
    getPrivacyPolicy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'PrivacyPolicy',
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
                data: privacyPolicy,
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
