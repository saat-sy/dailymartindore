import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/all.dart';
import 'package:frontend/screens/products/productpage.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';

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

    _apiResponseAll = await service.getAllProducts();
    if (_apiResponseAll.error) {
      setState(() {
        error = _apiResponseAll.errorMessage;
      });
    } else {
      allProducts = _apiResponseAll.data;
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
        title: Text('More Deals'),
        centerTitle: true,
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
        
         : ProductCard(

          items: allProducts,

        ),
      ) 
    );
  }
}