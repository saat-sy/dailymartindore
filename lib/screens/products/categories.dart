import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/products/all.dart';
import 'package:frontend/screens/products/productpage.dart';
import 'package:frontend/stylesheet/styles.dart';

class Categories extends StatefulWidget {
  int category;
  Categories({this.category});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  List<String> categoryTitle = [
    'Bakery, Cakes & Dairy',
    'Foodgrains, Oil & Masala',
    'Fruits & Vegetables',
    'House Hold Care',
    'Snacks & Packaged Foods'
  ];

  List<AllProducts> allProducts = [
    AllProducts(
        imagePath: 'assets/images/veg3.png',
        title: 'Fresh Apricots',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: "4.5",
        old_price: "160",
        new_price: "130"),
    AllProducts(
        imagePath: 'assets/images/veg1.png',
        title: 'Organic Lemons',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: "2.8",
        old_price: "160",
        new_price: "130"),
    AllProducts(
        imagePath: 'assets/images/veg2.png',
        title: 'Pomogrenate',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: "4.8",
        old_price: "160",
        new_price: "130"),
    AllProducts(
        imagePath: 'assets/images/veg3.png',
        title: 'Pomogrenate',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: "5.0",
        old_price: "160",
        new_price: "130"),
    AllProducts(
        imagePath: 'assets/images/veg1.png',
        title: 'Organic Lemons',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: "4.2",
        old_price: "160",
        new_price: "130"),
    AllProducts(
        imagePath: 'assets/images/veg2.png',
        title: 'Fresh Apricots',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: "3.8",
        old_price: "160",
        new_price: "130"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:Colors.white,

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(categoryTitle[widget.category], style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: ProductCard(

        items: allProducts,

      )
    );
  }
}
