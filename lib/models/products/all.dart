import 'package:flutter/material.dart';

class AllProducts {
  String imagePath;
  String title;
  String description;
  bool isVeg;
  double rating;
  double old_price;
  double new_price;

  AllProducts(
      {this.imagePath,
      this.title,
      this.description,
      this.isVeg,
      this.rating,
      this.old_price,
      this.new_price});
}

