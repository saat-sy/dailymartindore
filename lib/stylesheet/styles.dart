import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/shopping_cart_model.dart';
import 'package:frontend/screens/products/productpage.dart';
import 'package:frontend/services/cart_service.dart';
import 'package:frontend/services/favorites_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class ProductCard extends StatefulWidget {
  final List items;
  final Function onAddToCartPress;

  const ProductCard({this.items, this.onAddToCartPress});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  FavoriteService service = FavoriteService();

  APIResponse<bool> _apiResponse;

  bool isLoading = true;

  String error;

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 55, width: 55, child: CircularProgressIndicator()),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  addToFavorites(String itemID, BuildContext context) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponse = await service.addToFavorites(id, itemID);

    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
      });
    }
    else {
      final snackBar = SnackBar(content: Text('Added to Wish List!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
  }

  CartService serviceCart = CartService();
  APIResponse<bool> _apiResponseCart;

  Future<void> addToCart({String productId, String price, BuildContext context}) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    ShoppingCartModel s = ShoppingCartModel(
        productID: productId,
        price: price,
        numAdded: '1',
        sumPrice: price
    );

        _apiResponseCart = await serviceCart.addToCart(id, s);
    if (_apiResponseCart.error) {
      setState(() {
        error = _apiResponseCart.errorMessage;
        Navigator.pop(context);
        print(error);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      final snackBar = SnackBar(content: Text('Added to Cart!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('Added to cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          childAspectRatio: 0.55,
        ),
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductPage(
                            id: widget.items[index].id,
                          )));
            },
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
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: [
                            Center(
                              child: Image.network(
                                widget.items[index].imagePath,
                                height: MediaQuery.of(context).size.height * 0.145,
                              ),
                            ),
                            widget.items[index].discount != null &&
                                    widget.items[index].discount != "0"
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: MyColors.PrimaryColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: Text('${widget.items[index].discount}%',
                                        style: TextStyle(color: Colors.white)))
                                : Container(),
                            GestureDetector(
                              onTap: () {
                                addToFavorites(widget.items[index].id, context);
                              },
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
                              widget.items[index].title.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.items[index].quantity + 'g',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.items[index].description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBarIndicator(
                                  rating: widget.items[index].rating != null
                                      ? double.parse(widget.items[index].rating)
                                      : 0,
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
                                          color: widget.items[index].isVeg
                                              ? Colors.green
                                              : Colors.red,
                                          width: 2)),
                                  child: Icon(
                                    Icons.circle,
                                    size: 10,
                                    color: widget.items[index].isVeg
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
                                  '₹' + widget.items[index].old_price.toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '₹' + widget.items[index].new_price.toString(),
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: MyColors.SecondaryColor,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          
                        ],
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        addToCart(
                          productId: widget.items[index].id,
                          price: widget.items[index].new_price.toString(),
                          context: context
                        );
                      },
                      child: Container(
                        height: 40,
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
                    ),
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

class HomeProductCard extends StatefulWidget {
  final List items;
  final Function onAddToCartPress;

  const HomeProductCard({this.items, this.onAddToCartPress});

  @override
  _HomeProductCardState createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<HomeProductCard> {

  FavoriteService service = FavoriteService();

  APIResponse<bool> _apiResponse;

  bool isLoading = true;

  String error;

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 55, width: 55, child: CircularProgressIndicator()),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  addToFavorites(String itemID) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponse = await service.addToFavorites(id, itemID);

    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
      });
    }
    else{
      final snackBar = SnackBar(content: Text('Added to Wish List!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
  }

  CartService serviceCart = CartService();
  APIResponse<bool> _apiResponseCart;

  Future<void> addToCart({String productId, String price}) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    ShoppingCartModel s = ShoppingCartModel(
        productID: productId,
        price: price,
        numAdded: '1',
        sumPrice: price
    );

        _apiResponseCart = await serviceCart.addToCart(id, s);
    if (_apiResponseCart.error) {
      setState(() {
        error = _apiResponseCart.errorMessage;
        Navigator.pop(context);
        print(error);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      final snackBar = SnackBar(content: Text('Added to Cart!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('Added to cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 335.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length > 6 ? 6 : widget.items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductPage(
                            id: widget.items[index].id != null
                                ? widget.items[index].id
                                : "33",
                          )));
            },
            child: Container(
              width: 175,
              margin: EdgeInsets.only(top: 8, bottom: 8, right: 10),
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
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Image.network(
                                  widget.items[index].imagePath,
                                  height:
                                      MediaQuery.of(context).size.height * 0.145,
                                ),
                              ),
                            ),
                            widget.items[index].discount != null &&
                                    widget.items[index].discount != "0"
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: MyColors.PrimaryColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: Text('${widget.items[index].discount}%',
                                        style: TextStyle(color: Colors.white)))
                                : Container(),
                            GestureDetector(
                              onTap: () {
                                addToFavorites(widget.items[index].id);
                              },
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
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              widget.items[index].title.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.items[index].quantity + 'g',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.items[index].description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBarIndicator(
                                  rating: widget.items[index].rating != null
                                      ? double.parse(widget.items[index].rating)
                                      : 0,
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
                                          color: widget.items[index].isVeg
                                              ? Colors.green
                                              : Colors.red,
                                          width: 2)),
                                  child: Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: widget.items[index].isVeg
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '₹' + widget.items[index].old_price.toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '₹' + widget.items[index].new_price.toString(),
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
                            height: 6,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        addToCart(
                          productId: widget.items[index].id,
                          price: widget.items[index].new_price.toString()
                          );
                        },
                      child: Container(
                        height: 35,
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
                    ),
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
