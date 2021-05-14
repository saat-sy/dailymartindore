import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/constants.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _animationControllerFav;
  Animation _colorTweenCart;
  Animation _colorTweenCartText;
  Animation _colorTweenFav;
  Animation _colorTweenFavText;

  String imagePath = 'assets/images/veg1.png';
  String title = 'Organic Lemons';
  String shortDescription =
      'Meyer Lemons are different from the small, tart and acidic lemons at your grocery store – the fruit is literally a cross between traditional sour lemons and sweet oranges. ';
  String description =
      'As you know, the fruit available at your grocery store is not chosen for flavor but rather shelf life – that is why the lemons available to you are small with very thick skin. Meyer Lemons are not available in grocery stores because the fruit skin is so wonderfully thin that it would bruise while riding in a crate – however, the thin skin is perfect for home chefs that want tantalizingly fresh fruit right off the branch! The thin skin allows the citrus juices to develop fully, making it the perfect raw fruit for juices, desserts, and flavoring.';
  double rating = 4.5;
  String brandName = 'Amul';
  String vendorName = 'Dilip';
  String price = '80';
  String oldPrice = '100';
  String discount = '20';
  String category = 'Food';

  String textCart = 'Add to Cart';
  String textFav = 'Add to Favorites';

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _colorTweenCart =
        ColorTween(begin: Colors.white, end: MyColors.PrimaryColor)
            .animate(_animationController);
    _colorTweenCartText =
        ColorTween(begin: MyColors.PrimaryColor, end: Colors.white)
            .animate(_animationController);

    _animationControllerFav =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _colorTweenFav = ColorTween(begin: Colors.white, end: MyColors.PrimaryColor)
        .animate(_animationControllerFav);
    _colorTweenFavText =
        ColorTween(begin: MyColors.PrimaryColor, end: Colors.white)
            .animate(_animationControllerFav);

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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: <Widget>[
              Image(
                image: AssetImage(imagePath),
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
                  Text(
                    brandName,
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
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
                    rating: rating,
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
                  Text('Price:'),
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
                      fontSize: 22,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            if(textCart == 'Added to Cart')
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
                  AnimatedBuilder(
                    animation: _colorTweenFav,
                    builder: (context, child) => Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: TextButton(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                                fontSize: 15, color: _colorTweenFavText.value),
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.favorite,
                                  color: _colorTweenFavText.value,
                                  size: 20,
                                ),
                              ),
                              TextSpan(
                                  text: textFav, style: TextStyle(fontSize: 15))
                            ],
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: _colorTweenFav.value,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                  color: MyColors.PrimaryColor, width: 2)),
                        ),
                        onPressed: () {
                          setState(() {
                            if(textFav == 'Added to Favorites')
                              textFav = 'Add to Favorites';
                            else 
                              textFav = 'Added to Favorites';
                          });
                          if (_animationControllerFav.status ==
                              AnimationStatus.completed) {
                            _animationControllerFav.reverse();
                          } else {
                            _animationControllerFav.forward();
                          }
                        },
                      ),
                    ),
                  )
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
        ));
  }
}
