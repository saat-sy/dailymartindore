import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/shopping_cart_model.dart';
import 'package:frontend/strings.dart';
import 'package:http/http.dart' as http;

class CartService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  Future<APIResponse<List<ShoppingCartModel>>> getCart(String userID) async {
    final header = await Strings.getHeaders();
    final body = {'user_id': userID,};
    return http
        .post(Uri.parse(API + '/getCart'), headers: header, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final cartItems = <ShoppingCartModel>[];
          for(int i = 1; i < 1000; i++){
            if(responseData[i.toString()] != null) {
              var data = responseData[i.toString()];
              final f = ShoppingCartModel(
                productID: data['product_id'],
                price: data['price'],
                sumPrice: data['sum_price'],
                numAdded: data['num_added'],
              );
              cartItems.add(f);
            }
          }
          return APIResponse<List<ShoppingCartModel>>(
            data: cartItems,
            error: false,
          );
        }
        return APIResponse<List<ShoppingCartModel>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<ShoppingCartModel>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error.toString());
      return APIResponse<List<ShoppingCartModel>>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<bool>> addToCart(String userId, ShoppingCartModel s) async {
    final header = await Strings.getHeaders();
    final body = {
      'user_id': userId,
      'product_id': s.productID,
      'price': s.price,
      'sum_price': s.price,
      'num_added': s.numAdded,
      'final_sum': s.sumPrice
    };

    return http
        .post(Uri.parse(API + '/addToCart'), headers: header, body: body)
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
      print(error);
      return APIResponse<bool>(
          data: false, error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<bool>> deleteFromCart({String userId, String productId}) async {
    final header = await Strings.getHeaders();
    final body = {
      'user_id': userId,
      'product_id': productId
    };

    return http
        .post(Uri.parse(API + '/removeCartItems'), headers: header, body: body)
        .then((value) {
          print(value.statusCode);
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
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

  Future<APIResponse<bool>> clearCart({String userId}) async {
    final header = await Strings.getHeaders();
    final body = {
      'user_id': userId,
    };

    return http
        .post(Uri.parse(API + '/clearCart'), headers: header, body: body)
        .then((value) {
          print(value.statusCode);
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
}
