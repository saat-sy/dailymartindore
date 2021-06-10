import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/search_model.dart';
import 'package:frontend/strings.dart';
import 'package:http/http.dart' as http;

class SearchService {

  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  Future<APIResponse<List<SearchModel>>> getSearchResults(
      String searchTerm, String sortOrder, String minPrice, String maxPrice, String color, String discount, String size, String ratings) {
    final body = {
      'search_in_title': searchTerm,
      'order_by': sortOrder,
      'colour_id': color ?? '',
      'minPrice': minPrice ?? '',
      'maxPrice': maxPrice ?? '',
      'size_id': size ?? '',
      'discount_id': discount ?? '',
      'rating': ratings ?? '',
    };

    return http
        .post(Uri.parse(API + '/getProducts'), headers: Strings.HEADERS, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final searchProducts = <SearchModel>[];
          for (var data in responseData) {
            final f = SearchModel(
              id: data['id'],
              imagePath: data['image'],
              title: data['title'],
              description: data['description'],
              isVeg: data['is_veg'] == "0" ? true : false,
              rating: data['avg_rating'],
              inStock: data['quantity'] == '0' ? false : true,
              oldPrice: data['old_price'],
              discount: data['discount_name'],
              newPrice: data['price'],
              quantity: data['quantity_info']
            );
            searchProducts.add(f);
          }
          return APIResponse<List<SearchModel>>(
            data: searchProducts,
            error: false,
          );
        }
        return APIResponse<List<SearchModel>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<SearchModel>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<List<SearchModel>>(
          error: true, errorMessage: 'An error occured');
    });
  }

}  