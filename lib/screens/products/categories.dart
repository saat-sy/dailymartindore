import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/categories_model.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Categories extends StatefulWidget {
  final String category;
  final String categoryName;
  final String subcategory;
  final String subcategoryName;
  Categories({
    this.category,
    this.categoryName,
    this.subcategory,
    this.subcategoryName,
  });

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  ProductService service = ProductService();

  APIResponse<List<CategoriesProduct>> _apiResponse;

  bool isLoading = true;

  String error = '';

  List<CategoriesProduct> categories;

  getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String fav = prefs.getString(PrefConstants.inFav) ?? "";
    String cart = prefs.getString(PrefConstants.inCart) ?? "";

    _apiResponse = await service.getCategoryProducts(
        category: widget.category, subCategory: widget.subcategory);
    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
        });
    } else {
      categories = _apiResponse.data;
      for (int i = 0; i < categories.length; i++) {
        fav.split(',').forEach((element) {
          if (element == categories[i].id) categories[i].inFav = true;
        });
        cart.split(',').forEach((element) {
          if (element == categories[i].id) categories[i].inCart = true;
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          title: Text(widget.categoryName ?? widget.subcategoryName),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: isLoading
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    error == '' ? CircularProgressIndicator() : Container(),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ))
              : ProductCard(
                  items: categories,
                ),
        ));
  }
}
