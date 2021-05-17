import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/favorites_model.dart';
import 'package:http/http.dart' as http;

class FavoriteService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  static const headers = {
    'authorization': 'LS',
    'device_id': '1235',
    'device_version': '1.0',
    'device_type': '1',
    'store_id': '9'
  };

  Future<APIResponse<List<FavoritesModel>>> getFavorites(String userId) {
    final body = {'user_id': userId};

    return http
        .post(Uri.parse(API + '/wishList'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final favorites = <FavoritesModel>[];
          for (var bigdata in responseData) {
            for (var data in bigdata) {
              final f = FavoritesModel(
                id: data['id'],
                imagePath: data['image'],
                title: data['title'],
                description: data['description'],
                rating: data['avg_rating'],
                oldPrice: data['old_price'],
                discount: data['discount_name'],
                price: data['price'],
              );
              favorites.add(f);
            }
          }
          return APIResponse<List<FavoritesModel>>(
            data: favorites,
            error: false,
          );
        }
        return APIResponse<List<FavoritesModel>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<FavoritesModel>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<List<FavoritesModel>>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<bool>> addToFavorites(String userId, String itemID) {
    final body = {'user_id': userId, 'article_id': itemID};

    return http
        .post(Uri.parse(API + '/addToWishList'), headers: headers, body: body)
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

  Future<APIResponse<bool>> removeFavorites(String userId, String itemID) {
    final body = {'user_id': userId, 'article_id': itemID};

    return http
        .post(Uri.parse(API + '/removeToWishList'), headers: headers, body: body)
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
