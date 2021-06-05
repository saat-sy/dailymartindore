class FeaturedProducts {
  String id;
  String imagePath;
  String title;
  String description;
  bool isVeg;
  String discount;
  String rating;
  String quantity;
  String oldPrice;
  String newPrice;
  bool inStock;
  bool inFav;
  bool inCart;

  FeaturedProducts(
      {this.id,
      this.imagePath,
      this.title,
      this.description,
      this.isVeg,
      this.inStock = true,
      this.inCart = false,
      this.inFav = false,
      this.discount,
      this.quantity,
      this.rating,
      this.oldPrice,
      this.newPrice});
}
