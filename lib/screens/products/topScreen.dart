import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/top.dart';
import 'package:frontend/screens/products/productpage.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';

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

    _apiResponseTop = await service.getTopProducts();
    if (_apiResponseTop.error) {
      setState(() {
        error = _apiResponseTop.errorMessage;
      });
    } else {
      topProducts = _apiResponseTop.data;
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
        title: Text('Top Deals'),
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

          items: topProducts,

        ),
      )
    );
  }
}