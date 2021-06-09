import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/strings.dart';
import 'package:http/http.dart' as http;

class AboutUsService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  Future<APIResponse<String>> aboutUs() {
    return http
        .get(Uri.parse(API + '/aboutUs'), headers: Strings.HEADERS)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          return APIResponse<String>(
            data: jsonData['responsedata']['data'],
            error: false,
          );
        }
        return APIResponse<String>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<String>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<String>(error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<String>> faq() {
    return http
        .get(Uri.parse(API + '/faq'), headers: Strings.HEADERS)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          return APIResponse<String>(
            data: jsonData['responsedata']['data'],
            error: false,
          );
        }
        return APIResponse<String>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<String>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<String>(error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<String>> terms() {
    return http
        .get(Uri.parse(API + '/termsAndConditions'), headers: Strings.HEADERS)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          return APIResponse<String>(
            data: jsonData['responsedata']['data'],
            error: false,
          );
        }
        return APIResponse<String>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<String>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<String>(error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<String>> privacyPolicy() {
    return http
        .get(Uri.parse(API + '/privacyPolicy'), headers: Strings.HEADERS)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          return APIResponse<String>(
            data: jsonData['responsedata']['description'],
            error: false,
          );
        }
        return APIResponse<String>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<String>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<String>(error: true, errorMessage: 'An error occured');
    });
  }
}
