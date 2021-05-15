import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/product.dart';
import 'package:frontend/services/products_service.dart';

class ProductPage extends StatefulWidget {

  String id;
  ProductPage({this.id});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _colorTweenCart;
  Animation _colorTweenCartText;

  ProductService service = ProductService();

  APIResponse<ProductModel> _apiResponse;

  bool isLoading = true;
  String error = "";

  ProductModel product;

  getProduct() async {
    _apiResponse = await service.getProductByID(widget.id);
    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
        print(error);
      });
    } else {
      product = _apiResponse.data ?? "";
      imagePath = product.image ?? "";
      title = product.title ?? "";
      shortDescription = product.shortDescription ?? "";
      description = product.description ?? "";
      rating = product.rating ?? "";
      brandName = product.brandName ?? "";
      vendorName = product.vendorName ?? "";
      price = product.price ?? "";
      oldPrice = product.oldPrice ?? "";
      discount = product.discount ?? "";
      category = product.category ?? ""; 
      isVeg = product.isVeg ?? true;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refresh() async {
    getProduct();
  }

  String imagePath = '';
  String title = '';
  String shortDescription = '';
  String description = '';
  String rating = '';
  String brandName = '';
  String vendorName = '';
  String price = '';
  String oldPrice = '';
  String discount = '';
  String category = '';

  String textCart = 'Add to Cart';
  bool isVeg = true;

  @override
  void initState() {

    getProduct();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _colorTweenCart =
        ColorTween(begin: Colors.white, end: MyColors.PrimaryColor)
            .animate(_animationController);
    _colorTweenCartText =
        ColorTween(begin: MyColors.PrimaryColor, end: Colors.white)
            .animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: isLoading ? Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              CircularProgressIndicator(),

              error != "" ? Text(
                error,
                style: TextStyle(color: Colors.red),
              ) : Container()

            ],
          ),
        )
         : Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: <Widget>[
                Image.network(
                  imagePath,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          brandName,
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(1.5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: isVeg ? Colors.green : Colors.red,
                                  width: 1.5)),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: isVeg ? Colors.green : Colors.red,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'By ' + vendorName,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      rating.toString(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    RatingBarIndicator(
                      rating: rating != "" ? double.parse(rating) : 0,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 15.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('MRP:'),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '\$' + oldPrice,
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                          decoration: TextDecoration.lineThrough),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '\$' + price,
                      style: TextStyle(
                        color: MyColors.PrimaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: MyColors.PrimaryColor.withOpacity(0.15)),
                      child: Center(
                        child: Text(
                          discount + '% OFF',
                          style: TextStyle(
                              color: MyColors.PrimaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _colorTweenCart,
                      builder: (context, child) => Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: TextButton(
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 15, color: _colorTweenCartText.value),
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.shopping_bag,
                                    color: _colorTweenCartText.value,
                                    size: 20,
                                  ),
                                ),
                                TextSpan(
                                    text: textCart,
                                    style: TextStyle(fontSize: 15))
                              ],
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: _colorTweenCart.value,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    color: MyColors.PrimaryColor, width: 2)),
                          ),
                          onPressed: () {
                            setState(() {
                              if (textCart == 'Added to Cart')
                                textCart = 'Add to Cart';
                              else
                                textCart = 'Added to Cart';
                            });
                            if (_animationController.status ==
                                AnimationStatus.completed) {
                              _animationController.reverse();
                            } else {
                              _animationController.forward();
                            }
                          },
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.favorite_outline,
                          color: MyColors.PrimaryColor,
                          size: 25,
                        ),
                        onPressed: () {}),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Quick Overview',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(shortDescription)
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Category: ' + category)),
                SizedBox(
                  height: 20,
                ),
                Container(
                    child: Divider(
                  color: Colors.grey,
                  height: 3,
                )),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'About the product',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(description)
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }
}
