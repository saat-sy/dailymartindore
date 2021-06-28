import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/all.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/strings.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllScreen extends StatefulWidget {
  @override
  _AllScreenState createState() => _AllScreenState();
}

class _AllScreenState extends State<AllScreen> {
  ProductService service = ProductService();

  APIResponse<List<AllProducts>> _apiResponseAll;

  bool isLoading = true;

  String error = '';

  List<AllProducts> allProducts;

  getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String fav = prefs.getString(PrefConstants.inFav) ?? "";
    String cart = prefs.getString(PrefConstants.inCart) ?? "";

    _apiResponseAll = await service.getAllProducts();
    if (_apiResponseAll.error) {
      if (mounted)
        setState(() {
          error = _apiResponseAll.errorMessage;
        });
    } else {
      allProducts = _apiResponseAll.data;
      for (int i = 0; i < allProducts.length; i++) {
        fav.split(',').forEach((element) {
          if (element == allProducts[i].id) allProducts[i].inFav = true;
        });
        cart.split(',').forEach((element) {
          if (element == allProducts[i].id) allProducts[i].inCart = true;
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
          title: Text(Strings.ALL_PRODUCTS_SCREEN_APPBAR),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: isLoading
              ? Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        error == "" ? CircularProgressIndicator() : Container(),
                        error != ""
                            ? Text(
                                error,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container()
                      ],
                    ),
                  ),
                )
              : ProductCard(
                  items: allProducts,
                ),
        ));
  }
}
