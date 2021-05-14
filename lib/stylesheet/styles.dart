import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constants.dart';

class SubmitButton extends StatelessWidget {
  final Function onPress;
  final String text;
  final double width;

  SubmitButton({this.onPress, this.text, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: TextButton(
        onPressed: onPress,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(MyColors.PrimaryColor),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final List items;
  final Function onCardPress;
  final Function onAddToCartPress;
  final Function onFavPress;

  const ProductCard({this.items, this.onCardPress, this.onAddToCartPress, this.onFavPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          childAspectRatio: 0.56,
        ),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: onCardPress,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: [
                        Center(
                          child: Image(
                            image: AssetImage(items[index].imagePath),
                            height: MediaQuery.of(context).size.height * 0.145,
                          ),
                        ),
                        Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                            decoration: BoxDecoration(
                                color: MyColors.PrimaryColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            child: Text('10%',
                                style: TextStyle(color: Colors.white))),
                        GestureDetector(
                          onTap: onFavPress,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13),
                                child: Icon(Icons.favorite_outline,
                                    color: MyColors.PrimaryColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          items[index].title.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          items[index].description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBarIndicator(
                              rating: items[index].rating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 16.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: items[index].isVeg
                                          ? Colors.green
                                          : Colors.red,
                                      width: 2)),
                              child: Icon(
                                Icons.circle,
                                size: 10,
                                color: items[index].isVeg
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '₹' + items[index].old_price.toString(),
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '₹' + items[index].new_price.toString(),
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: MyColors.SecondaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: onAddToCartPress,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: MyColors.PrimaryColor,
                          ),
                          child: Center(
                            child: Text(
                              'ADD TO CART',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeProductCard extends StatelessWidget {

  final List items;
  final Function onCardPress;
  final Function onAddToCartPress;
  final Function onFavPress;

  const HomeProductCard({this.items, this.onCardPress, this.onAddToCartPress, this.onFavPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 286.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: onCardPress,
            child: Container(
              width: 175,
              margin: EdgeInsets.only(
                  top: 8, bottom: 8, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Image(
                              image: AssetImage(items[index].imagePath),
                              height: MediaQuery.of(context).size.height * 0.122,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                          decoration: BoxDecoration(
                            color: MyColors.PrimaryColor,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10))
                          ),
                          child: Text('10%', style: TextStyle(color: Colors.white))
                        ),
                        GestureDetector(
                          onTap: onFavPress,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                              child: Icon(Icons.favorite_outline, color: MyColors.PrimaryColor)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          items[index].title.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      SizedBox(height: 5,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          items[index].description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                        ),
                      ),

                      SizedBox(height: 7,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBarIndicator(
                              rating: items[index].rating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 16.0,
                            ),

                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: items[index].isVeg ? Colors.green : Colors.red, width: 2)
                              ),
                              child: Icon(Icons.circle, size: 10, color: items[index].isVeg ? Colors.green : Colors.red,),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 7,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '₹' +
                                  items[index]
                                      .old_price
                                      .toString(),
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  decoration:
                                      TextDecoration.lineThrough),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '₹' +
                                  items[index]
                                      .new_price
                                      .toString(),
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: MyColors.SecondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 6,),

                      InkWell(
                        onTap: onAddToCartPress,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: MyColors.PrimaryColor,
                          ),
                          child: Center(
                            child: Text(
                              'ADD TO CART',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      )

                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}