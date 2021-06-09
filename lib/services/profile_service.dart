import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/strings.dart';
import 'package:http/http.dart' as http;

class ProfileService {

  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  Future<APIResponse<bool>> updateProfile(String phoneNo, String name, String userID) {
    final body = {
      'user_id': userID,
      'name': name,
      'phone': phoneNo
    };

    return http
        .post(Uri.parse(API + '/updateProfile'), headers: Strings.HEADERS, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        print(jsonData);
        if (jsonData['responseCode'] == 1) {
          return APIResponse<bool>(
            data: true,
            error: false,
          );
        }
        return APIResponse<bool>(
            data: false,
            error: true,
            errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<bool>(
          data: false,
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<bool>(
          data: false, error: true, errorMessage: 'An error occured');
    });
  }

}  