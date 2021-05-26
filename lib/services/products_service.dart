import 'dart:convert';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/all.dart';
import 'package:frontend/models/products/categories_model.dart';
import 'package:frontend/models/products/featured.dart';
import 'package:frontend/models/products/product.dart';
import 'package:frontend/models/products/store_list_model.dart';
import 'package:frontend/models/products/top.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  static const headers = {
    'authorization': 'LS',
    'device_id': '1235',
    'device_version': '1.0',
    'device_type': '1',
    'store_id': '14'
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
              quantity: data['quantity']
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
              quantity: data['quantity']
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
              quantity: data['quantity']
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
          print(responseData['id']);
          final product = ProductModel(
              id: responseData['id'],
              categoryID: responseData['shop_categorie'],
              title: responseData['title'],
              isVeg: responseData['is_veg'] == "0" ? true : false,
              rating: responseData['avg_rating'],
              image: [responseData['image']],
              discount: responseData['discount_name'],
              description: responseData['description'],
              shortDescription: responseData['short_description'],
              brandName: responseData['brand_name'],
              vendorName: responseData['vendor_name'],
              price: responseData['price'],
              oldPrice: responseData['old_price'],
              sku: responseData['sku'],
              category: responseData['categorie_name']);
          return APIResponse<ProductModel>(error: false, data: product);
        }
        return APIResponse<ProductModel>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<ProductModel>(
          error: true, errorMessage: 'An error occured');
    }).catchError((error) {
      print(error);
      return APIResponse<ProductModel>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<List<CategoriesModel>>> getCategories() {
    return http
        .get(Uri.parse(API + '/getCategory'), headers: headers)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final categories = <CategoriesModel>[];

          for (var data in responseData) {

            final subCategories = <SubCategoriesModel>[];
            for (var sub in data['subcategory']) {

              final subSubCat = <SubSubCategoriesModel>[];
              for(var subsub in sub['subsubcategory']) {
                final ss = SubSubCategoriesModel(
                  id: subsub['id'],
                  name: subsub['name'],
                  image: subsub['image'],
                );
                subSubCat.add(ss);

              }

              final s = SubCategoriesModel(
                id: sub['id'],
                name: sub['name'],
                image: sub['image'],
                subSubCategoriesModel: subSubCat ?? [],
              );
              subCategories.add(s);
            }

            final f = CategoriesModel(
              id: data['id'],
              name: data['name'],
              image: data['image'],
              subCategories: subCategories ?? [],
            );
            categories.add(f);
          }

          return APIResponse<List<CategoriesModel>>(
            data: categories,
            error: false,
          );
        }
        return APIResponse<List<CategoriesModel>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<CategoriesModel>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error);
      return APIResponse<List<CategoriesModel>>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<List<CategoriesProduct>>> getCategoryProducts(
      {String category, String subCategory}) {
    final body = {
      'category': category ?? '',
      'subcategory': subCategory ?? ''
    };

    return http
        .post(Uri.parse(API + '/getProducts'), headers: headers, body: body)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        print(jsonData);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final categoryProducts = <CategoriesProduct>[];
          for (var data in responseData) {
            final f = CategoriesProduct(
              id: data['id'],
              imagePath: data['image'],
              title: data['title'],
              description: data['description'],
              isVeg: data['is_veg'] == "0" ? true : false,
              rating: data['avg_rating'],
              old_price: data['old_price'],
              discount: data['discount_name'],
              new_price: data['price'],
              quantity: data['quantity']
            );
            categoryProducts.add(f);
          }
          return APIResponse<List<CategoriesProduct>>(
            data: categoryProducts,
            error: false,
          );
        }
        return APIResponse<List<CategoriesProduct>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<CategoriesProduct>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error);
      return APIResponse<List<CategoriesProduct>>(
          error: true, errorMessage: 'An error occured');
    });
  }

  Future<APIResponse<List<StoreListModel>>> getStoreList() {
    return http
        .get(Uri.parse(API + '/storeList'), headers: headers)
        .then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['storeList'];
          final stores = <StoreListModel>[];
          for (var data in responseData) {
            final f = StoreListModel(
              id: data['id'],
              address: data['address'],
              pinCode: data['pincode'],
            );
            stores.add(f);
          }
          return APIResponse<List<StoreListModel>>(
            data: stores,
            error: false,
          );
        }
        return APIResponse<List<StoreListModel>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<StoreListModel>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error.toString());
      return APIResponse<List<StoreListModel>>(
          error: true, errorMessage: 'An error occured');
    });
  }
}
