import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/featured.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/strings.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeaturedScreen extends StatefulWidget {
  @override
  _FeaturedScreenState createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  ProductService service = ProductService();

  APIResponse<List<FeaturedProducts>> _apiResponseFeat;

  bool isLoading = true;

  String error = '';

  List<FeaturedProducts> featuredProducts;

  getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String fav = prefs.getString(PrefConstants.inFav) ?? "";
    String cart = prefs.getString(PrefConstants.inCart) ?? "";

    _apiResponseFeat = await service.getFeaturedProducts();
    if (_apiResponseFeat.error) {
      setState(() {
        error = _apiResponseFeat.errorMessage;
      });
    } else {
      featuredProducts = _apiResponseFeat.data;
      for (int i = 0; i < featuredProducts.length; i++) {
        print(featuredProducts[i].id);
        fav.split(',').forEach((element) {
          if (element == featuredProducts[i].id)
            featuredProducts[i].inFav = true;
        });
        cart.split(',').forEach((element) {
          if (element == featuredProducts[i].id)
            featuredProducts[i].inCart = true;
        });
      }
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
          title: Text(Strings.FEATURED_PRODUCTS_SCREEN_APPBAR),
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
                  items: featuredProducts,
                ),
        ));
  }
}
