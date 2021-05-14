import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/products/top.dart';
import 'package:frontend/screens/products/productpage.dart';
import 'package:frontend/stylesheet/styles.dart';

class TopScreen extends StatelessWidget {

  List<TopProducts> topProducts = [
    TopProducts(
        imagePath: 'assets/images/veg2.png',
        title: 'Fresh Apricots',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: 4.5,
        old_price: 199.99,
        new_price: 149.99),
    TopProducts(
        imagePath: 'assets/images/veg3.png',
        title: 'Pomogrenate',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: 2.8,
        old_price: 137,
        new_price: 130),
    TopProducts(
        imagePath: 'assets/images/veg1.png',
        title: 'Organic Lemons',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: 4.8,
        old_price: 145,
        new_price: 130),
    TopProducts(
        imagePath: 'assets/images/veg2.png',
        title: 'Fresh Apricots',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: false,
        rating: 5.0,
        old_price: 160,
        new_price: 130),
    TopProducts(
        imagePath: 'assets/images/veg3.png',
        title: 'Pomogrenate',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: 4.2,
        old_price: 160,
        new_price: 130),
    TopProducts(
        imagePath: 'assets/images/veg1.png',
        title: 'Organic Lemons',
        description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
        isVeg: true,
        rating: 3.8,
        old_price: 160,
        new_price: 130),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Top Deals', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: ProductCard(

        items: topProducts,

        onFavPress: () {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Add to Favorite"),
              content: Text("This will be implemented when I do the functionality"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Ok"),
                ),
              ],
            ),
          );
        },

        onAddToCartPress: () {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Add to Cart"),
              content: Text("This will be implemented when I do the functionality"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Ok"),
                ),
              ],
            ),
          );
        },

        onCardPress: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage()));
        },

      )
    );
  }
}