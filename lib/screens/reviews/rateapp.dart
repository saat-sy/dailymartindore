import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/reviews/reviews_model.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/services/reviews_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class RateApp extends StatefulWidget {
  String productID;
  RateApp({this.productID});
  @override
  _RateAppState createState() => _RateAppState();
}

class _RateAppState extends State<RateApp> {
  ReviewService service = ReviewService();
  APIResponse<bool> _apiResponse;
  String error;

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 55, width: 55, child: CircularProgressIndicator()),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  addReview() async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    ReviewsModel reviewsModel = ReviewsModel(
        review: review,
        productID: widget.productID,
        rating: rating,
        userID: id);

    _apiResponse = await service.addReview(reviewsModel);

    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
      });
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  String rating;
  String review;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Write Review',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'What do you think?',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Please give your rating by clicking on the stars below.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                this.rating = rating.toString();
              },
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              onChanged: (val) {
                review = val;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              cursorColor: MyColors.PrimaryColor,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  hintText: 'Tell us about your experience',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Visibility(
                      visible: true,
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.grey,
                        size: 17,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0))),
            ),
            SizedBox(
              height: 30,
            ),
            SubmitButton(
              text: 'Submit',
              onPress: () {
                addReview();
              },
            ),
          ],
        ),
      ),
    );
  }
}
