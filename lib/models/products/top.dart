class TopProducts {
  String id;
  String imagePath;
  String title;
  String description;
  bool isVeg;
  String discount;
  String rating;
  String quantity;
  String oldPrice;
  bool inStock;
  String newPrice;
  bool inFav;
  bool inCart;

  TopProducts(
      {this.id,
      this.imagePath,
      this.title,
      this.description,
      this.isVeg,
      this.inStock = true,
      this.inCart = false,
      this.inFav = false,
      this.quantity,
      this.discount,
      this.rating,
      this.oldPrice,
      this.newPrice});
}
