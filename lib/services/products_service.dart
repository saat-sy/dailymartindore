import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/all.dart';
import 'package:frontend/models/products/featured.dart';
import 'package:frontend/models/products/product.dart';
import 'package:frontend/models/products/top.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  static const headers = {
    'authorization': 'LS',
    'device_id': '1235',
    'device_version': '1.0',
    'device_type': '1',
    'store_id': '9'
  };

  Future<APIResponse<List<FeaturedProducts>>> getFeaturedProducts() {
    return http
        .get(Uri.parse(API + '/getFeaturedProducts'), headers: headers)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final featuredProducts = <FeaturedProducts>[];
          for (var data in responseData) {
            final f = FeaturedProducts(
              id: data['id'],
              imagePath: data['image'],
              title: data['title'],
              description: data['description'],
              isVeg: data['is_veg'] == "0" ? true : false,
              rating: data['avg_rating'],
              old_price: data['old_price'],
              discount: data['discount_name'],
              new_price: data['price'],
            );
            featuredProducts.add(f);
          }
          return APIResponse<List<FeaturedProducts>>(
            data: featuredProducts,
            error: false,
          );
        }
        return APIResponse<List<FeaturedProducts>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<FeaturedProducts>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<List<FeaturedProducts>>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<List<TopProducts>>> getTopProducts() {
    return http
        .get(Uri.parse(API + '/getTopProducts'), headers: headers)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final topProducts = <TopProducts>[];
          for (var data in responseData) {
            final f = TopProducts(
              id: data['id'],
              imagePath: data['image'],
              title: data['title'],
              description: data['description'],
              isVeg: data['is_veg'] == "0" ? true : false,
              rating: data['avg_rating'],
              old_price: data['old_price'],
              discount: data['discount_name'],
              new_price: data['price'],
            );
            topProducts.add(f);
          }
          return APIResponse<List<TopProducts>>(
            data: topProducts,
            error: false,
          );
        }
        return APIResponse<List<TopProducts>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<TopProducts>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<List<TopProducts>>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<List<AllProducts>>> getAllProducts() {
    return http
        .get(Uri.parse(API + '/getSaleProducts'), headers: headers)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final allProducts = <AllProducts>[];
          for (var data in responseData) {
            final f = AllProducts(
              id: data['id'],
              imagePath: data['image'],
              title: data['title'],
              description: data['description'],
              isVeg: data['is_veg'] == "0" ? true : false,
              rating: data['avg_rating'],
              old_price: data['old_price'],
              discount: data['discount_name'],
              new_price: data['price'],
            );
            allProducts.add(f);
          }
          return APIResponse<List<AllProducts>>(
            data: allProducts,
            error: false,
          );
        }
        return APIResponse<List<AllProducts>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<AllProducts>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      return APIResponse<List<AllProducts>>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<ProductModel>> getProductByID(String id) {
    final body = {"product_id": id};

    return http
        .post(Uri.parse(API + '/getProductbyId'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final product = ProductModel(
            title: responseData['title'],
            isVeg: responseData['is_veg'] == "0" ? true : false,
            rating: responseData['avg_rating'],
            image: responseData['image'],
            discount: responseData['discount_name'],
            description: responseData['description'],
            shortDescription: responseData['short_description'],
            brandName: responseData['brand_name'],
            vendorName: responseData['vendor_name'],
            price: responseData['price'],
            oldPrice: responseData['old_price'],
            category: responseData['categorie_name']
          );
          return APIResponse<ProductModel>(
            error: false, data: product);
        }
        return APIResponse<ProductModel>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<ProductModel>(
            error: true, errorMessage: 'An error occured');
    }).catchError((error) {
      return APIResponse<ProductModel>(
          error: true, errorMessage: 'An error occured');
    });
  }
}
