class OrderDetails {
  String orderID;
  String total;
  String type;
  String productTitle;
  String price;
  String image;
  String quantity;
  bool isExpanded;

  OrderDetails(
      {this.image,
      this.isExpanded: false,
      this.orderID,
      this.price,
      this.productTitle,
      this.quantity,
      this.total,
      this.type});
}
