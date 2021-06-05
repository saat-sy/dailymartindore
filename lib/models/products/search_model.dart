class SearchModel {
  String id;
  String imagePath;
  String title;
  String description;
  bool isVeg;
  String discount;
  String quantity;
  String rating;
  bool inFav;
  bool inStock;
  bool inCart;
  String oldPrice;
  String newPrice;

  SearchModel(
      {this.id,
      this.imagePath,
      this.title,
      this.quantity,
      this.description,
      this.inStock = true,
      this.inCart = false,
      this.inFav = false,
      this.isVeg,
      this.discount,
      this.rating,
      this.oldPrice,
      this.newPrice});
}
