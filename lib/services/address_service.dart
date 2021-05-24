import 'dart:convert';
import 'package:frontend/models/address/address_model.dart';
import 'package:frontend/models/api_response.dart';
import 'package:http/http.dart' as http;

class AddressService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  static const headers = {
    'authorization': 'LS',
    'device_id': '1235',
    'device_version': '1.0',
    'device_type': '1',
    'store_id': '14'
  };

  Future<APIResponse<List<AddressModel>>> getAddressList(String userID) {
    final body = {'user_id': userID};

    return http
        .post(Uri.parse(API + '/addressList'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          print(jsonData);
          final responseData = jsonData['responsedata'];
          final address = <AddressModel>[];
          for (var bigdata in responseData) {
            for (var data in bigdata) {
              print(data['username']);
              final f = AddressModel(
                id: data['id'],
                username: data['username'] ?? "User",
                address: data['address'],
                city: data['city'],
                state: data['state'],
                pincode: data['pincode'],
                isDefault: data['is_default'] ?? "0" == "0" ? false: true,
              );
              address.add(f);
            }
          }
          return APIResponse<List<AddressModel>>(
              data: address,
              error: false);
        }
        return APIResponse<List<AddressModel>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<AddressModel>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<List<AddressModel>>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<bool>> addAddress(
      AddressModel addressModel, String userId) {
    final body = {
      'user_id': userId,
      'username': addressModel.username,
      'address': addressModel.address,
      'city': addressModel.city,
      'state': addressModel.state,
      'pincode': addressModel.pincode,
    };

    return http
        .post(Uri.parse(API + '/addAddress'), headers: headers, body: body)
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

  Future<APIResponse<bool>> updateAddress(
      AddressModel addressModel, String userId) {
    final body = {
      'user_id': userId,
      'username': addressModel.username,
      'address': addressModel.address,
      'city': addressModel.city,
      'state': addressModel.state,
      'pincode': addressModel.pincode,
      'id': addressModel.id,
      'is_default': '0'
    };

    return http
        .post(Uri.parse(API + '/updateAddress'), headers: headers, body: body)
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

  Future<APIResponse<bool>> removeAddress(
      String itemId, String userId) {
    final body = {
      'user_id': userId,
      'id': itemId
    };

    return http
        .post(Uri.parse(API + '/removeAddress'), headers: headers, body: body)
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
