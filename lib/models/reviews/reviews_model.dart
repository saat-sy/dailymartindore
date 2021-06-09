class ReviewsModel {
  String userID;
  String productID;
  String orderID;
  String username;
  String rating;
  String review;

  ReviewsModel({this.rating, this.review, this.orderID, this.username, this.userID, this.productID});
}