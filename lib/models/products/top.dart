class TopProducts {
  String id;
  String imagePath;
  String title;
  String description;
  bool isVeg;
  String discount;
  String rating;
  String quantity;
  String old_price;
  String new_price;

  TopProducts(
      {this.id,
      this.imagePath,
      this.title,
      this.description,
      this.isVeg,
      this.quantity,
      this.discount,
      this.rating,
      this.old_price,
      this.new_price});
}
