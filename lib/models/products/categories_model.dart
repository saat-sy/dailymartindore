class CategoriesModel {
  String id;
  String name;
  String image;
  List<SubCategoriesModel> subCategories;

  CategoriesModel({this.id, this.name, this.image, this.subCategories});
}

class SubCategoriesModel {
  String id;
  String name;
  String image;
  List<SubSubCategoriesModel> subSubCategoriesModel;

  SubCategoriesModel({this.id, this.name, this.image, this.subSubCategoriesModel});
}

class SubSubCategoriesModel {
  String id;
  String name;
  String image;
  String parentId;

  SubSubCategoriesModel({this.id, this.name, this.image});
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
  String quantity;
  String new_price;

  CategoriesProduct(
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
