import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/reviews/reviews_model.dart';
import 'package:frontend/services/reviews_service.dart';

class Reviews extends StatefulWidget {
  String id;
  Reviews({this.id});
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {

  ReviewService service = ReviewService();
  APIResponse<List<ReviewsModel>> _apiResponse;
  bool isLoading = true;
  String error;
  bool _recordFound = false;

  List<ReviewsModel> reviews;

  getReviews() async {

    _apiResponse = await service.getReviews(widget.id);

    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
        isLoading = false;
      });
    } else {
      reviews = _apiResponse.data;
      setState(() {
        isLoading = false;
        _recordFound = true;
      });
    }
  }


  // List<ReviewsModel> reviews = [
  //   ReviewsModel(
  //       username: 'User 1',
  //       rating: '5.0',
  //       review:
  //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
  //   ReviewsModel(
  //       username: 'User 2',
  //       rating: '4.0',
  //       review:
  //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
  //   ReviewsModel(
  //       username: 'User 3',
  //       rating: '5.0',
  //       review:
  //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
  //   ReviewsModel(
  //       username: 'User 4',
  //       rating: '4.5',
  //       review:
  //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
  //   ReviewsModel(
  //       username: 'User 5',
  //       rating: '5.0',
  //       review:
  //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
  //   ReviewsModel(
  //       username: 'User 6',
  //       rating: '5.0',
  //       review:
  //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '),
  // ];

  @override
  void initState() {
    getReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('Reviews'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : !_recordFound
          ? Center(
        child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/empty_favorites.png",
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                Text('No Reviews found',
                    style: TextStyle(fontSize: 23))
              ]),
        ),
      ) : Container(
        child: ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image(
                          image: AssetImage('assets/images/profile.png'),
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        reviews[index].username,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(child: Divider(color: Colors.grey, height: 1,),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        reviews[index].rating.toString(),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      RatingBarIndicator(
                        rating: double.parse(reviews[index].rating),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 15.0,
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(reviews[index].review),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
