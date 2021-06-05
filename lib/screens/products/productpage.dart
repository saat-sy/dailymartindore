import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/categories_model.dart';
import 'package:frontend/models/products/product.dart';
import 'package:frontend/models/products/shopping_cart_model.dart';
import 'package:frontend/screens/reviews/rateapp.dart';
import 'package:frontend/screens/reviews/reviews.dart';
import 'package:frontend/services/cart_service.dart';
import 'package:frontend/services/favorites_service.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  final String id;
  final bool inStock;
  ProductPage({this.id, this.inStock});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _colorTweenCart;
  Animation _colorTweenCartText;

  ProductService service = ProductService();
  CartService serviceCart = CartService();
  FavoriteService serviceFav = FavoriteService();

  APIResponse<bool> _apiResponseFav;
  APIResponse<ProductModel> _apiResponse;
  APIResponse<bool> _apiResponseCart;

  bool isLoading = true;
  String error = "";
  bool isLoadingCart = true;
  String errorCart = "";

  ProductModel product;
  List<ShoppingCartModel> cart;

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
    String fav = prefs.getString(PrefConstants.inFav) ?? "";

    _apiResponseFav = await serviceFav.addToFavorites(id, itemID);

    if (_apiResponseFav.error) {
      if (mounted)
        setState(() {
          error = _apiResponseFav.errorMessage;
        });
    } else {
      if (fav.isNotEmpty) fav += ',';
      fav += itemID;
      await prefs.setString(PrefConstants.inFav, fav);

      if (mounted)
        setState(() {
          product.inFav = true;
        });

      final snackBar = SnackBar(content: Text('Added to Wish List!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
  }

  removeFavorites(String itemID) async {
    showLoaderDialog(context);

    String newFav;

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();
    String fav = prefs.getString(PrefConstants.inFav) ?? "";

    _apiResponseFav = await serviceFav.removeFavorites(id, itemID);

    if (_apiResponseFav.error) {
      if (mounted)
        setState(() {
          error = _apiResponseFav.errorMessage;
        });
    } else {
      if (mounted)
        setState(() {
          product.inFav = false;
        });

      if (fav != "") {
        fav.split(',').forEach((element) {
          if (newFav.isNotEmpty) newFav += ',';
          if (element != itemID) newFav += element;
        });
      }
      await prefs.setString(PrefConstants.inFav, newFav);
    }
    final snackBar = SnackBar(content: Text('Removed from Wish List'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  addToCart() async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();
    String cartString = prefs.getString(PrefConstants.inCart) ?? "";

    ShoppingCartModel s = ShoppingCartModel(
        productID: product.id,
        price: product.price,
        numAdded: quantity.toString(),
        sumPrice: (double.parse(product.price) * quantity).toString());

    _apiResponseCart = await serviceCart.addToCart(id, s);
    if (_apiResponseCart.error) {
      if (mounted)
        setState(() {
          error = _apiResponseCart.errorMessage;
          Navigator.pop(context);
          print(error);
        });
    } else {
      if (cartString.isNotEmpty) cartString += ',';
      cartString += product.id;
      await prefs.setString(PrefConstants.inCart, cartString);
      if (mounted)
        setState(() {
          isLoading = false;
        });
      final snackBar = SnackBar(content: Text('Added to Cart'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
      print('Added to Cart!');
    }
  }

  deleteFromCart({String itemID}) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getInt(PrefConstants.id).toString();
    String cart = prefs.getString(PrefConstants.inCart) ?? "";
    String newCart = "";

    print(itemID);

    _apiResponseCart =
        await serviceCart.deleteFromCart(userId: userId, productId: itemID);

    if (_apiResponseCart.error) {
      if (mounted)
        setState(() {
          error = _apiResponseCart.errorMessage;
        });
    } else {
      if (cart != "") {
        cart.split(',').forEach((element) {
          if (newCart.isNotEmpty) newCart += ',';
          if (element != itemID) newCart += element;
        });
        await prefs.setString(PrefConstants.inCart, newCart);
      }
    }
    final snackBar = SnackBar(content: Text('Removed from Cart'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  Future<void> getProduct() async {
    final prefs = await SharedPreferences.getInstance();
    String cart = prefs.getString(PrefConstants.inCart) ?? "";
    String recent = prefs.getString(PrefConstants.recentProducts) ?? "";

    _apiResponse = await service.getProductByID(widget.id);
    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
          print(error);
        });
    } else {
      product = _apiResponse.data;
      product.imageArr.insert(0, product.image);
      cart.split(',').forEach((element) {
        if (element == product.id) product.inCart = true;
      });

      String newRecent = "";

      if (recent != "") {
        final l = recent.split(',');
        if (l.length >= 10) {
          for (int i = 0; i <= 8; i++) {
            if (newRecent.isNotEmpty) newRecent += ',';
            newRecent += l[i];
          }
        } else
          newRecent = recent;
      }

      if (newRecent.isNotEmpty) newRecent = ',' + newRecent;
      newRecent = widget.id + newRecent;

      await prefs.setString(PrefConstants.recentProducts, newRecent);

      if (mounted) if (mounted)
        setState(() {
          isLoading = false;
        });
      getCategories();
    }
  }

  Future<void> refresh() async {
    await getProduct();
  }

  String textCart;

  @override
  void initState() {
    getProduct();
    textCart = widget.inStock ? 'Add to Cart' : 'Out of Stock';

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

  int quantity = 1;
  updateQuantity(int i) {
    if (mounted)
      setState(() {
        if (i == 1)
          quantity++;
        else if (i == 0 && quantity > 1) quantity--;
      });
  }

  int currentImageIndex = 0;

  PageController pageController = PageController();

  void animateToNextPage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  _onPageViewChange(int page) {
    if (mounted)
      setState(() {
        currentImageIndex = page;
      });
  }

  ProductService serviceCat = ProductService();

  APIResponse<List<CategoriesProduct>> _apiResponseCat;

  bool isCatLoading = true;

  String errorCat = '';

  List<CategoriesProduct> categories;

  Future<void> getCategories() async {
    _apiResponseCat =
        await serviceCat.getCategoryProducts(category: product.categoryID);
    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          errorCat = _apiResponseCat.errorMessage;
          print(errorCat);
        });
    } else {
      categories = _apiResponseCat.data;
      if (mounted)
        setState(() {
          isCatLoading = false;
        });
    }
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: isLoading
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      error != ""
                          ? Text(
                              error,
                              style: TextStyle(color: Colors.red),
                            )
                          : Container()
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: product.imageArr.length,
                          onPageChanged: _onPageViewChange,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                              startingIndex: index,
                                              product: product.imageArr,
                                            )));
                              },
                              child: Hero(
                                tag: 'imageHero',
                                child: Image.network(
                                  product.imageArr[index],
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Center(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: product.imageArr.length,
                            itemBuilder: (context, index) {
                              return index == currentImageIndex
                                  ? Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyColors.PrimaryColor,
                                              width: 2)),
                                      child: Image.network(
                                        product.imageArr[index],
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        if (mounted)
                                          setState(() {
                                            currentImageIndex = index;
                                            animateToNextPage(
                                                currentImageIndex);
                                          });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          product.imageArr[index],
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                product.brandName,
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: product.isVeg
                                            ? Colors.green
                                            : Colors.red,
                                        width: 1.5)),
                                child: Icon(
                                  Icons.circle,
                                  size: 10,
                                  color:
                                      product.isVeg ? Colors.green : Colors.red,
                                ),
                              )
                            ],
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
                            product.rating != null ? product.rating : '0',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          RatingBarIndicator(
                            rating: product.rating != null
                                ? double.parse(product.rating)
                                : 0,
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
                        height: 7.5,
                      ),
                      widget.inStock
                          ? Text(
                              'In Stock',
                              style: TextStyle(
                                  color: MyColors.SecondaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            )
                          : Text(
                              'Out of Stock',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                      SizedBox(
                        height: 7.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('MRP:'),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '₹' + product.oldPrice,
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 18,
                                decoration: TextDecoration.lineThrough),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '₹' + product.price,
                            style: TextStyle(
                              color: MyColors.SecondaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    MyColors.SecondaryColor.withOpacity(0.15)),
                            child: Center(
                              child: Text(
                                product.discount + '% OFF',
                                style: TextStyle(
                                    color: MyColors.SecondaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      textCart == 'Added to Cart'
                          ? Row(
                              children: [
                                Text('Quantity: '),
                                InkWell(
                                  onTap: () {
                                    updateQuantity(0);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1.5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade600),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5))),
                                    child: Text('–',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.grey.shade600,
                                            width: 1),
                                        bottom: BorderSide(
                                            color: Colors.grey.shade600,
                                            width: 1)),
                                  ),
                                  child: Text(quantity.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.SecondaryColor)),
                                ),
                                InkWell(
                                  onTap: () {
                                    updateQuantity(1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1.5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade600),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5))),
                                    child: Text('+',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
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
                                        fontSize: 15,
                                        color: _colorTweenCartText.value),
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
                                          color: MyColors.PrimaryColor,
                                          width: 2)),
                                ),
                                onPressed: () {
                                  if (widget.inStock) {
                                    if (mounted)
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
                                    addToCart();
                                  }
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (product.inFav)
                                removeFavorites(product.id);
                              else
                                addToFavorites(product.id);
                            },
                            child: product.inFav
                                ? Icon(Icons.favorite,
                                    color: Colors.redAccent.shade400)
                                : Icon(Icons.favorite_outline,
                                    color: MyColors.PrimaryColor),
                          ),
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
                            Text(product.shortDescription)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SKU: ',
                                style: TextStyle(color: MyColors.PrimaryColor),
                              ),
                              Text(product.sku),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Category: ',
                                style: TextStyle(color: MyColors.PrimaryColor),
                              ),
                              Text(product.category),
                            ],
                          )),
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
                      DefaultTabController(
                        length: 3,
                        initialIndex: 0,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: Center(
                                  child: TabBar(
                                    isScrollable: true,
                                    labelColor: Colors.white,
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                    unselectedLabelStyle: TextStyle(
                                        fontWeight: FontWeight.normal),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    unselectedLabelColor: Colors.grey,
                                    indicator: BoxDecoration(
                                        color: MyColors.PrimaryColor,
                                        borderRadius: BorderRadius.circular(6)),
                                    tabs: [
                                      Container(
                                        height: 30.0,
                                        child: Tab(
                                          child: Text('Description'),
                                        ),
                                      ),
                                      Container(
                                        height: 30.0,
                                        child: Tab(
                                          child: Text('Additional Info'),
                                        ),
                                      ),
                                      Container(
                                        height: 30.0,
                                        child: Tab(
                                          child: Text('Reviews'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  height: 200,
                                  child: TabBarView(children: <Widget>[
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'About the product',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Expanded(
                                                child: SingleChildScrollView(
                                                    child: Text(
                                                        product.description)))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Table(
                                        children: [
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Brand',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(product.brandName),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('SKU',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(product.sku),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Category',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(product.category),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Merchant',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(product.vendorName),
                                            ),
                                          ]),
                                        ],
                                        border: TableBorder.all(
                                            width: 1,
                                            color: Colors.grey.shade400),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            children: [
                                              Text(
                                                'Review this Product',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                  'Share your thoughts with other customers'),
                                              SizedBox(
                                                height: 7,
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RateApp(
                                                            productID:
                                                                product.id,
                                                          )));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: MyColors.PrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Text(
                                                'Write a Review',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Reviews(
                                                                id: product
                                                                    .id)));
                                              },
                                              child: Text(
                                                'View All Reviews',
                                                style: TextStyle(
                                                    color:
                                                        MyColors.SecondaryColor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ]))
                            ]),
                      ),
                      Text(
                        'Related Products',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      isCatLoading
                          ? Container(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : HomeProductCard(
                              items: categories,
                            ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
        ));
  }
}

class DetailScreen extends StatefulWidget {
  final List product;
  final int startingIndex;
  DetailScreen({this.startingIndex, this.product});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List imagePath = [];

  PageController pageController;

  @override
  initState() {
    imagePath = widget.product;
    pageController = PageController(initialPage: widget.startingIndex ?? 0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4,
          child: Center(
            child: Hero(
              tag: 'imageHero',
              child: PageView.builder(
                controller: pageController,
                itemCount: imagePath.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    imagePath[index],
                    width: MediaQuery.of(context).size.width,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
