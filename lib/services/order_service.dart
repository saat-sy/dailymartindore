import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/order/order_model.dart';
import 'package:frontend/models/order/payment_models.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  static const headers = {
    'authorization': 'LS',
    'device_id': '1235',
    'device_version': '1.0',
    'device_type': '1',
    'store_id': '14'
  };

  Future<APIResponse<bool>> placeOrder(OrderModel orderModel) {
    final body = {
      'user_id': orderModel.userID,
      'product_id': orderModel.id,
      'first_name': orderModel.firstName,
      'last_name': orderModel.lastName,
      'email': orderModel.email,
      'phone': orderModel.phone,
      'address': orderModel.address,
      'city': orderModel.city,
      'post_code': orderModel.postCode,
      'notes': 'notes',
      'payment_type': orderModel.paymentType,
      'quantity': orderModel.quantity,
      'total_amount': orderModel.totalAmount,
    };

    return http
        .post(Uri.parse(API + '/makeOrder'), headers: headers, body: body)
        .then((value) {
      print('status code: '+ value.statusCode.toString());
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
      print(error);
      return APIResponse<bool>(
          data: false, error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<bool>> applyCoupon(String coupon) {
    final body = {'coupon': coupon};

    return http
        .post(Uri.parse(API + '/applyCoupon'), headers: headers, body: body)
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

  Future<APIResponse<List<PaymentMethods>>> getPaymentList() {
    return http
        .get(Uri.parse(API + '/getPaymentModeList'), headers: headers)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final methods = <PaymentMethods>[];
          for (var data in responseData) {
            final f = PaymentMethods(
              value: data['value'],
              name: data['name'],
            );
            methods.add(f);
          }
          return APIResponse<List<PaymentMethods>>(
            data: methods,
            error: false,
          );
        }
        return APIResponse<List<PaymentMethods>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<PaymentMethods>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error);
      return APIResponse<List<PaymentMethods>>(
          error: true, errorMessage: 'An error occured');
    });
  }
}
