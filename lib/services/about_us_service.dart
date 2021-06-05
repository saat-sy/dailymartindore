import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:http/http.dart' as http;

class AboutUsService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  static const headers = {
    'authorization': 'LS',
    'device_id': '1235',
    'device_version': '1.0',
    'device_type': '1',
    'store_id': '14'
  };

  Future<APIResponse<String>> aboutUs() {
    return http
        .get(Uri.parse(API + '/aboutUs'), headers: headers)
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
        .get(Uri.parse(API + '/faq'), headers: headers)
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
        .get(Uri.parse(API + '/termsAndConditions'), headers: headers)
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
}
