class SearchModel {
  String id;
  String imagePath;
  String title;
  String description;
  bool isVeg;
  String discount;
  String quantity;
  String rating;
  String old_price;
  String new_price;

  SearchModel(
      {this.id,
      this.imagePath,
      this.title,
      this.quantity,
      this.description,
      this.isVeg,
      this.discount,
      this.rating,
      this.old_price,
      this.new_price});
}
