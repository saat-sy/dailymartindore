class CategoriesModel {
  String id;
  String name;
  String image;

  CategoriesModel({
    this.id,
    this.name,
    this.image
  });
}

class CategoriesProduct {
  String id;
  String imagePath;
  String title;
  String description;
  bool isVeg;
  String discount;
  String rating;
  String old_price;
  String new_price;

  CategoriesProduct(
      {this.id,
      this.imagePath,
      this.title,
      this.description,
      this.isVeg,
      this.discount,
      this.rating,
      this.old_price,
      this.new_price});
}
