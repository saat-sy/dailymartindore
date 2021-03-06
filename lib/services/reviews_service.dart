import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/reviews/reviews_model.dart';
import 'package:frontend/strings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReviewService {
  static const API = 'http://4percentmedical.com/dks/grocery/Api/Restapi';

  Future<APIResponse<bool>> addReview(ReviewsModel reviewsModel) async {
    final header = await Strings.getHeaders();
    final body = {
      'user_id': reviewsModel.userID,
      'product_id': reviewsModel.productID,
      'rating': reviewsModel.rating,
      'review': reviewsModel.review,
      'order_id': reviewsModel.orderID
    };

    return http
        .post(Uri.parse(API + '/addReviewRating'),
            headers: header, body: body)
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

  Future<APIResponse<List<ReviewsModel>>> getReviews(String productId) async {
    final header = await Strings.getHeaders();
    final body = {'product_id': productId,};
    return http
        .post(Uri.parse(API + '/getProductReview'), headers: header, body: body)
        .then((value) {
          print(value.statusCode);
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body);
        if (jsonData['responseCode'] == 1) {
          final responseData = jsonData['responsedata'];
          final cartItems = <ReviewsModel>[];
          print(responseData);
          for (var data in responseData) {
            print(data);
            final f = ReviewsModel(
              review: data['review'] ?? '',
              rating: data['rating'] ?? '',
              username: data['name'] ?? '',
            );
            cartItems.add(f);
          }
          return APIResponse<List<ReviewsModel>>(
            data: cartItems,
            error: false,
          );
        }
        return APIResponse<List<ReviewsModel>>(
            error: true, errorMessage: jsonData['responseMessage']);
      }
      return APIResponse<List<ReviewsModel>>(
          error: true,
          errorMessage: json.decode(value.body)['responseMessage']);
    }).catchError((error) {
      print(error.toString());
      return APIResponse<List<ReviewsModel>>(
          error: true, errorMessage: 'An error occured');
    });
  }
}
