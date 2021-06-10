import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/authenticate/getting_started.dart';
import 'package:frontend/screens/authenticate/login.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/screens/bottomnav/bottomnav_anonymous.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/favorites_model.dart';
import 'package:frontend/models/products/product.dart';
import 'package:frontend/models/products/shopping_cart_model.dart';
import 'package:frontend/services/cart_service.dart';
import 'package:frontend/services/favorites_service.dart';
import 'package:frontend/services/products_service.dart';

SharedPreferences prefs;

getFavs() async {
  FavoriteService service = FavoriteService();
  APIResponse<List<FavoritesModel>> _apiResponse;
  List<FavoritesModel> favorites;

  String favs = "";

  final prefs = await SharedPreferences.getInstance();
  String id = prefs.getInt(PrefConstants.id).toString() ?? "-1";

  _apiResponse = await service.getFavorites(id);

  if (!_apiResponse.error) {
    favorites = _apiResponse.data;
    for (final fav in favorites) {
      if (favs.isNotEmpty) favs += ',';
      favs += fav.id;
    }
  }

  if (favs.length >= 0) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefConstants.inFav, favs);
  }
}

getCart() async {
  String cart = "";

  CartService service = CartService();
  APIResponse<List<ShoppingCartModel>> _apiResponse;

  List<ShoppingCartModel> items2;

  final prefs = await SharedPreferences.getInstance();
  String id = prefs.getInt(PrefConstants.id).toString() ?? "-1";

  _apiResponse = await service.getCart(id);
  if (!_apiResponse.error) {
    items2 = _apiResponse.data;

    ProductService serviceProduct = ProductService();
    APIResponse<ProductModel> _apiResponseProduct;
    ProductModel p = ProductModel();

    for (var item in items2) {
      _apiResponseProduct = await serviceProduct.getProductByID(item.productID);
      if (!_apiResponseProduct.error) {
        p = _apiResponseProduct.data;
        if (cart.isNotEmpty) cart += ',';
        cart += p.id;
      }
    }
  }

  if (cart.length >= 0) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefConstants.inCart, cart);
  }
}

class Wrapper extends StatelessWidget {
  Future<String> _getWidget() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(PrefConstants.name) ?? "";
    bool firstOpen = prefs.getBool(PrefConstants.firstOpen) ?? true;
    String fav = prefs.getString(PrefConstants.inFav) ?? "";
    String cart = prefs.getString(PrefConstants.inCart) ?? "";

    if (name == "") {
      await prefs.setString(PrefConstants.name, "");
    }

    if (name != "") await getFavs();

    if (name != "") await getCart();


    if (firstOpen) {
      await prefs.setBool(PrefConstants.firstOpen, false);
      return 'Getting Started';
    } else
      return name;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getWidget(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == 'Getting Started')
            return GettingStarted();
          else if (snapshot.data == "" || snapshot.data == null)
            return BottomNavAnonymous();
          else
            return BottomNav();
        } else
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Loading...')
                ],
              ),
            ),
          );
      },
    );
  }
}
