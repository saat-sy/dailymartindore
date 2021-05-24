import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/all.dart';
import 'package:frontend/models/products/categories_model.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';

class Categories extends StatefulWidget {
  String category;
  String categoryName;
  Categories({this.category, this.categoryName});

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

    _apiResponse = await service.getCategoryProducts(widget.category);
    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
      });
    } else {
      categories = _apiResponse.data;
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

  // List<AllProducts> allProducts = [
  //   AllProducts(
  //       imagePath: 'assets/images/veg3.png',
  //       title: 'Fresh Apricots',
  //       description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
  //       isVeg: true,
  //       rating: "4.5",
  //       old_price: "160",
  //       new_price: "130"),
  //   AllProducts(
  //       imagePath: 'assets/images/veg1.png',
  //       title: 'Organic Lemons',
  //       description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
  //       isVeg: true,
  //       rating: "2.8",
  //       old_price: "160",
  //       new_price: "130"),
  //   AllProducts(
  //       imagePath: 'assets/images/veg2.png',
  //       title: 'Pomogrenate',
  //       description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
  //       isVeg: true,
  //       rating: "4.8",
  //       old_price: "160",
  //       new_price: "130"),
  //   AllProducts(
  //       imagePath: 'assets/images/veg3.png',
  //       title: 'Pomogrenate',
  //       description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
  //       isVeg: true,
  //       rating: "5.0",
  //       old_price: "160",
  //       new_price: "130"),
  //   AllProducts(
  //       imagePath: 'assets/images/veg1.png',
  //       title: 'Organic Lemons',
  //       description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
  //       isVeg: true,
  //       rating: "4.2",
  //       old_price: "160",
  //       new_price: "130"),
  //   AllProducts(
  //       imagePath: 'assets/images/veg2.png',
  //       title: 'Fresh Apricots',
  //       description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ',
  //       isVeg: true,
  //       rating: "3.8",
  //       old_price: "160",
  //       new_price: "130"),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:Colors.white,

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text(widget.categoryName),
        centerTitle: true,
      ),

      body: RefreshIndicator(

        onRefresh: refresh,

        child: isLoading ? 
        
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(error, style: TextStyle(color: Colors.red),)
          ],
        ))

          : ProductCard(

          items: categories,

        ),
      )
    );
  }
}
