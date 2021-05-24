class ShoppingCartModel {
  String imagePath;
  String title;
  String price;
  String oldPrice;
  String rating;
  String discount;
  String description;
  String productID;
  String numAdded;
  String sumPrice;

  ShoppingCartModel(
      {this.imagePath,
      this.title,
      this.price,
      this.oldPrice,
      this.discount,
      this.rating,
      this.productID,
      this.numAdded,
      this.sumPrice,
      this.description});
}
