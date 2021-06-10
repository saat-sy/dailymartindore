import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/shopping_cart_model.dart';
import 'package:frontend/screens/authenticate/login.dart';
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

  bool isLoggedIn = true;

  String error;

  checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(PrefConstants.name).toString() ?? "";
    if (name == "") {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

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

  addToFavorites(String itemID, int index) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();
    String fav = prefs.getString(PrefConstants.inFav) ?? "";

    _apiResponse = await service.addToFavorites(id, itemID);

    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
        });
    } else {
      if (fav.isNotEmpty) fav += ',';
      fav += itemID;
      await prefs.setString(PrefConstants.inFav, fav);

      if (mounted)
        setState(() {
          widget.items[index].inFav = true;
        });

      final snackBar = SnackBar(content: Text('Added to Wish List!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
  }

  removeFavorites(String itemID, int index) async {
    showLoaderDialog(context);

    String newFav;

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();
    String fav = prefs.getString(PrefConstants.inFav) ?? "";

    _apiResponse = await service.removeFavorites(id, itemID);

    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
        });
    } else {
      if (mounted)
        setState(() {
          widget.items[index].inFav = false;
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

  CartService serviceCart = CartService();
  APIResponse<bool> _apiResponseCart;

  addToCart({String productId, String price, int index}) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();
    String cart = prefs.getString(PrefConstants.inCart) ?? "";

    ShoppingCartModel s = ShoppingCartModel(
        productID: productId, price: price, numAdded: '1', sumPrice: price);

    _apiResponseCart = await serviceCart.addToCart(id, s);
    if (_apiResponseCart.error) {
      if (mounted)
        setState(() {
          error = _apiResponseCart.errorMessage;
          Navigator.pop(context);
          print(error);
        });
    } else {
      if (cart.isNotEmpty) cart += ',';
      cart += productId;
      await prefs.setString(PrefConstants.inCart, cart);
      if (mounted)
        setState(() {
          isLoading = false;
          widget.items[index].inCart = true;
        });
      Navigator.pop(context);
      final snackBar = SnackBar(content: Text('Added to Cart!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  deleteFromCart({String itemID, int index}) async {
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
      if (mounted)
        setState(() {
          widget.items[index].inCart = false;
        });

      if (cart != "") {
        cart.split(',').forEach((element) {
          if (newCart.isNotEmpty) newCart += ',';
          if (element != itemID) newCart += element;
        });
      }
      await prefs.setString(PrefConstants.inCart, newCart);
    }
    final snackBar = SnackBar(content: Text('Removed from Cart'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
        itemCount: widget.items.length,
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductPage(
                            id: widget.items[index].id,
                            inStock: widget.items[index].inStock,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.145,
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
                                    child: Text(
                                        '${widget.items[index].discount}%',
                                        style: TextStyle(color: Colors.white)))
                                : Container(),
                            GestureDetector(
                              onTap: () {
                                if (isLoggedIn)
                                  widget.items[index].inFav
                                      ? removeFavorites(
                                          widget.items[index].id, index)
                                      : addToFavorites(
                                          widget.items[index].id, index);
                                else
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text('Login/Signup'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Please login or Sign up to add to favorites',
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              SubmitButton(
                                                text: 'Login',
                                                onPress: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Login()));
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      });
                              },
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.13),
                                    child: widget.items[index].inFav
                                        ? Icon(Icons.favorite,
                                            color: Colors.redAccent.shade400)
                                        : Icon(Icons.favorite_outline,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.items[index].title.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.items[index].quantity,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '₹' + widget.items[index].oldPrice.toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '₹' + widget.items[index].newPrice.toString(),
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: MyColors.SecondaryColor,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.items[index].inStock) if (isLoggedIn)
                            widget.items[index].inCart
                                ? deleteFromCart(itemID: widget.items[index].id)
                                : addToCart(
                                    productId: widget.items[index].id,
                                    price: widget.items[index].newPrice
                                        .toString());
                          else
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text('Login/Signup'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Please login or Sign up to add to cart',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SubmitButton(
                                          text: 'Login',
                                          onPress: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Login()));
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                });
                        },
                        child: Container(
                          //height: 40,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: MyColors.PrimaryColor,
                          ),
                          child: Center(
                              child: widget.items[index].inStock
                                  ? Text(
                                      widget.items[index].inCart
                                          ? 'IN CART'
                                          : 'ADD TO CART',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )
                                  : Text(
                                      'OUT OF STOCK',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )),
                        ),
                      ),
                    ],
                  ),
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

  addToFavorites(String itemID, int index) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();
    String fav = prefs.getString(PrefConstants.inFav) ?? "";

    _apiResponse = await service.addToFavorites(id, itemID);

    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
        });
    } else {
      if (fav.isNotEmpty) fav += ',';
      fav += itemID;
      await prefs.setString(PrefConstants.inFav, fav);

      if (mounted)
        setState(() {
          widget.items[index].inFav = true;
        });

      final snackBar = SnackBar(content: Text('Added to Wish List!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
  }

  removeFavorites(String itemID, int index) async {
    showLoaderDialog(context);

    String newFav = "";

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();
    String fav = prefs.getString(PrefConstants.inFav) ?? "";

    _apiResponse = await service.removeFavorites(id, itemID);

    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
        });
    } else {
      if (mounted)
        setState(() {
          widget.items[index].inFav = false;
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

  CartService serviceCart = CartService();
  APIResponse<bool> _apiResponseCart;

  addToCart({String productId, String price, int index}) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();
    String cart = prefs.getString(PrefConstants.inCart) ?? "";

    ShoppingCartModel s = ShoppingCartModel(
        productID: productId, price: price, numAdded: '1', sumPrice: price);

    _apiResponseCart = await serviceCart.addToCart(id, s);
    if (_apiResponseCart.error) {
      if (mounted)
        setState(() {
          error = _apiResponseCart.errorMessage;
          Navigator.pop(context);
          print(error);
        });
    }
    if (cart.isNotEmpty) cart += ',';
    cart += productId;
    await prefs.setString(PrefConstants.inCart, cart);
    if (mounted)
      setState(() {
        isLoading = false;
        widget.items[index].inCart = true;
      });
    Navigator.pop(context);
    final snackBar = SnackBar(content: Text('Added to Cart!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  deleteFromCart({String itemID, int index}) async {
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
    }
    if (mounted)
      setState(() {
        widget.items[index].inCart = false;
      });

    if (cart != "") {
      cart.split(',').forEach((element) {
        if (newCart.isNotEmpty) newCart += ',';
        if (element != itemID) newCart += element;
      });
    }
    await prefs.setString(PrefConstants.inCart, newCart);
    final snackBar = SnackBar(content: Text('Removed from Cart'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  bool isLoggedIn = true;

  checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(PrefConstants.name).toString() ?? "";
    if (name == "") {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: widget.items.map(
        (item) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductPage(
                            id: item.id != null ? item.id : "33",
                            inStock: item.inStock,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Image.network(
                              item.imagePath,
                              height: MediaQuery.of(context).size.height *
                                  0.145,
                            ),
                          ),
                        ),
                        item.discount != null && item.discount != "0"
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 10),
                                decoration: BoxDecoration(
                                    color: MyColors.PrimaryColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))),
                                child: Text('${item.discount}%',
                                    style: TextStyle(color: Colors.white)))
                            : Container(),
                        GestureDetector(
                          onTap: () {
                            if (isLoggedIn)
                              item.inFav
                                  ? removeFavorites(
                                      item.id, widget.items.indexOf(item))
                                  : addToFavorites(
                                      item.id, widget.items.indexOf(item));
                            else
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text('Login/Signup'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Please login or Sign up to add to favorites',
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          SubmitButton(
                                            text: 'Login',
                                            onPress: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login()));
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  });
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                margin: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height *
                                            0.13),
                                child: item.inFav
                                    ? Icon(Icons.favorite,
                                        color: Colors.redAccent.shade400)
                                    : Icon(Icons.favorite_outline,
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          item.title.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          item.quantity,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 30,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          item.description,
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBarIndicator(
                              rating: item.rating != null
                                  ? double.parse(item.rating)
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
                                      color: item.isVeg
                                          ? Colors.green
                                          : Colors.red,
                                      width: 2)),
                              child: Icon(
                                Icons.circle,
                                size: 8,
                                color:
                                    item.isVeg ? Colors.green : Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '₹' + item.oldPrice.toString(),
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '₹' + item.newPrice.toString(),
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: MyColors.SecondaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        if (item.inStock) if (isLoggedIn)
                          item.inCart
                              ? deleteFromCart(itemID: item.id)
                              : addToCart(
                                  productId: item.id,
                                  price: item.newPrice.toString());
                        else
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text('Login/Signup'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Please login or Sign up to add to cart',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      SubmitButton(
                                        text: 'Login',
                                        onPress: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()));
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                      },
                      child: Container(
                        height: 35,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: MyColors.PrimaryColor,
                        ),
                        child: Center(
                            child: item.inStock
                                ? Text(
                                    item.inCart ? 'IN CART' : 'ADD TO CART',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )
                                : Text(
                                    'OUT OF STOCK',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ).toList()),
    );
  }
}
