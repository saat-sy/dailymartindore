import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/top.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/strings.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopScreen extends StatefulWidget {
  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  ProductService service = ProductService();

  APIResponse<List<TopProducts>> _apiResponseTop;

  bool isLoading = true;

  String error = '';

  List<TopProducts> topProducts;

  getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String fav = prefs.getString(PrefConstants.inFav) ?? "";
    String cart = prefs.getString(PrefConstants.inCart) ?? "";

    _apiResponseTop = await service.getTopProducts();
    if (_apiResponseTop.error) {
      if (mounted)
        setState(() {
          error = _apiResponseTop.errorMessage;
        });
    } else {
      topProducts = _apiResponseTop.data;
      for (int i = 0; i < topProducts.length; i++) {
        fav.split(',').forEach((element) {
          if (element == topProducts[i].id) topProducts[i].inFav = true;
        });
        cart.split(',').forEach((element) {
          if (element == topProducts[i].id) topProducts[i].inCart = true;
        });
      }
      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }

  Future<void> refresh() async {
    getProducts();
  }

  @override
  initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title: Text(Strings.TOP_PRODUCTS_SCREEN_APPBAR),
          centerTitle: true,
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
              : ProductCard(
                  items: topProducts,
                ),
        ));
  }
}
