import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/order/order_details_model.dart';
import 'package:frontend/models/order/order_model.dart';
import 'package:frontend/models/order/payment_models.dart';
import 'package:frontend/models/order/track_order_model.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  static const headers = {
    'authorization': 'LS',
    'device_id': '1235',
    'device_version': '1.0',
    'device_type': '1',
    'store_id': '14',
  };

  Future<APIResponse<bool>> placeOrder(OrderModel orderModel) {
    final body = {
      'first_name': orderModel.firstName,
      'last_name': orderModel.lastName,
      'email': orderModel.email,
      'phone': orderModel.phone,
      'city': orderModel.city,
      'post_code': orderModel.postCode,
      'notes': 'tgdex',
      'address': orderModel.address,
      'payment_type': orderModel.paymentType,
      'id': orderModel.id,
      'quantity': orderModel.quantity,
      'total_amount': orderModel.totalAmount,
      'shipping_charges': '',
      'discountCode': '',
      'amount_currency': '',
      'discountAmount': '',
      'sgst': '',
      'cgst': '',
      'user_id': orderModel.userID,
    };

    return http
        .post(Uri.parse(API + "/makeOrder/"), headers: headers, body: body)
        .then((value) {
      final jsonData = json.decode(value.body);
      if (value.statusCode == 200) {
        print(jsonData);
        if (jsonData['responseCode'] == 1) {
          print('true');
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

  Future<APIResponse<List<OrderDetails>>> getMyOrders(String id) {
    final body = {"user_id": id};

    return http
        .post(Uri.parse(API + '/myOrders'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];

          final orderDetails = <OrderDetails>[];

          for (var data in responseData) {
            final productData = data['products'];
            final o = OrderDetails(
                orderID: data['order_id'],
                total: data['total'],
                type: data['type'],
                image: productData['image'],
                productTitle: productData['product_name'],
                price: productData['price'],
                quantity: productData['product_quantity']);
            orderDetails.add(o);
          }

          return APIResponse<List<OrderDetails>>(
            data: orderDetails,
            error: false,
          );
        }
        return APIResponse<List<OrderDetails>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<OrderDetails>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error);
      return APIResponse<List<OrderDetails>>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<List<TrackOrderModel>>> trackOrder(String orderID) {
    final body = {'order_id': orderID};

    return http
        .post(Uri.parse(API + '/trackOrder'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        final orderData = jsonData['order_process'];
        final track = <TrackOrderModel>[];

        for (final data in orderData) {
          final t = TrackOrderModel(
              status: data['status'], date: data['created_at']);
          track.add(t);
        }

        return APIResponse<List<TrackOrderModel>>(
          data: track,
          error: false,
        );
      }
      return APIResponse<List<TrackOrderModel>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error);
      return APIResponse<List<TrackOrderModel>>(
          error: true, errorMessage: 'An error occured');
    });
  }
}
