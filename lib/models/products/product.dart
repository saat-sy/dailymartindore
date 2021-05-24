class ProductModel {
  String title;
  String id;
  bool isVeg;
  String rating;
  List<String> image;
  String discount;
  String description;
  String shortDescription;
  String brandName;
  String vendorName;
  String price;
  String oldPrice;
  String category;
  String sku;
  String quantity;
  String categoryID;

  ProductModel(
      {this.id,
      this.title,
      this.isVeg,
      this.category,
      this.rating,
      this.sku,
      this.quantity,
      this.categoryID,
      this.image,
      this.discount,
      this.description,
      this.shortDescription,
      this.brandName,
      this.vendorName,
      this.price,
      this.oldPrice});
}
