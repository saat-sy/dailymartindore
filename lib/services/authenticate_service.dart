import 'dart:convert';

import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/authenticate/signup_model.dart';
import 'package:frontend/models/user.dart';

import 'package:http/http.dart' as http;

class AuthenticateService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  static const headers = {
    'authorization': 'LS',
    'device_id': '1235',
    'device_version': '1.0',
    'device_type': '1',
    'store_id': '14'
  };

  Future<APIResponse<SignUpModel>> signup(SignUpInputModel input) {
    var body = {
      'name': input.name,
      'phone': input.phoneNo,
      'email': input.email,
      'password': input.password,
      'cpassword': input.cpassword,
    };

    return http
        .post(Uri.parse(API + '/register/'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final signupData = SignUpModel(otp: jsonData['otp']);
          print(jsonData['otp']);
          return APIResponse<SignUpModel>(data: signupData);
        }
        return APIResponse<SignUpModel>(
            error: true,
            errorMessage: json.decode(value.body)['responseMessage']);
      }
      print('FAILURE');
      return APIResponse<SignUpModel>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<SignUpModel>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<User>> verifyOTP(String email, int otp) {
    var body = {
      'email': email,
      'otp': otp.toString(),
    };

    return http
        .post(Uri.parse(API + '/VerifyOTP'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];

          final userData = User(
              name: responseData['name'],
              phoneNo: responseData['phone'],
              email: responseData['email'],
              userID: responseData['id']);

          return APIResponse<User>(data: userData);
        }
        return APIResponse<User>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      print('FAILURE');
      return APIResponse<User>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<User>(error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<User>> login(String email, String password) {
    var body = {
      'email': email,
      'password': password,
    };

    return http
        .post(Uri.parse(API + '/login'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          print(responseData);

          final userData = User(
              name: responseData['name'],
              phoneNo: responseData['phone'],
              email: responseData['email'],
              userID: int.parse(responseData['id']));

          return APIResponse<User>(data: userData);
        }
        return APIResponse<User>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      print('FAILURE');
      return APIResponse<User>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<User>(error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<bool>> changePassword(
      {String password, String cpassword, String opassword, String userID}) {
    var body = {
      'password': password,
      'cpassword': cpassword,
      'opassword': opassword,
      'user_id': userID,
    };

    return http
        .post(Uri.parse(API + '/changePassword'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        print(jsonDecode(value.body));
        if (jsonDecode(value.body)['responseCode'] == 1) {
          return APIResponse<bool>(error: false, data: true);
        }
        return APIResponse<bool>(
            error: true,
            errorMessage: json.decode(value.body)['responseMessage']);
      }
      return APIResponse<bool>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error);
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<String>> forgotPassword(String email) {
    var body = {
      'email': email,
    };

    return http
        .post(Uri.parse(API + '/forgotPassword'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        print(jsonDecode(value.body));
        if (jsonDecode(value.body)['responseCode'] == 1) {
          return APIResponse<String>(
              error: false, data: jsonDecode(value.body)['responseMessage']);
        }
        return APIResponse<String>(
            error: true,
            errorMessage: json.decode(value.body)['responseMessage']);
      }
      return APIResponse<String>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error);
      return APIResponse<String>(error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<User>> resendOTP(String phone) {
    var body = {
      'phone': phone,
    };

    return http
        .post(Uri.parse(API + '/resendOtp'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        if (jsonDecode(value.body)['responseCode'] == 1) {
          print('SUCCESS!!');
          print(jsonDecode(value.body)['otp']);
          return APIResponse<User>(error: false);
        }
        return APIResponse<User>(
            error: true,
            errorMessage: json.decode(value.body)['responseMessage']);
      }
      print('FAILURE');
      return APIResponse<User>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error);
      return APIResponse<User>(error: true, errorMessage: 'An error occured');
    });
  }
}
