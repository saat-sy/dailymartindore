import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/all.dart';
import 'package:frontend/models/products/categories_model.dart';
import 'package:frontend/models/products/featured.dart';
import 'package:frontend/models/products/top.dart';
import 'package:frontend/screens/products/allScreen.dart';
import 'package:frontend/screens/products/categories.dart';
import 'package:frontend/screens/products/featuredScreen.dart';
import 'package:frontend/screens/products/topScreen.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';

import 'package:frontend/constants.dart';

class BannerDashBoard {
  String imagePath;
  String text;

  BannerDashBoard({this.imagePath, this.text});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ProductService service = ProductService();

  APIResponse<List<FeaturedProducts>> _apiResponseFeat;
  APIResponse<List<TopProducts>> _apiResponseTop;
  APIResponse<List<AllProducts>> _apiResponseAll;
  APIResponse<List<CategoriesModel>> _apiResponseCategory;

  bool isFeatLoading = true;
  bool isTopLoading = true;
  bool isAllLoading = true;
  bool isCatLoading = true;
  String errorFeat = '';
  String errorTop = '';
  String errorAll = '';
  String errorCat = '';

  List<FeaturedProducts> featuredProducts;
  List<TopProducts> topProducts;
  List<AllProducts> allProducts;
  List<CategoriesModel> categories;

  getProducts() async {

    //GET FEATURED PRODUCTS
    _apiResponseFeat = await service.getFeaturedProducts();
    if (_apiResponseFeat.error) {
      setState(() {
        errorFeat = _apiResponseFeat.errorMessage;
      });
    } else {
      featuredProducts = _apiResponseFeat.data;
      if(mounted)
        setState(() {
          isFeatLoading = false;
        });
    }

    //GET TOP PRODUCTS
    _apiResponseTop = await service.getTopProducts();
    if (_apiResponseTop.error) {
      setState(() {
        errorTop = _apiResponseTop.errorMessage;
      });
    } else {
      topProducts = _apiResponseTop.data;
      if(mounted)
        setState(() {
          isTopLoading = false;
        });
    }

    //GET ALL PRODUCTS
    _apiResponseAll = await service.getAllProducts();
    if (_apiResponseAll.error) {
      setState(() {
        errorAll = _apiResponseAll.errorMessage;
      });
    } else {
      allProducts = _apiResponseAll.data;
      if(mounted)
        setState(() {
          isAllLoading = false;
        });
    }

    //GET CATEGORIES
    _apiResponseCategory = await service.getCategories();
    if (_apiResponseCategory.error) {
      setState(() {
        errorCat = _apiResponseCategory.errorMessage;
      });
    } else {
      categories = _apiResponseCategory.data;
      if(mounted)
        setState(() {
          isCatLoading = false;
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

  List<BannerDashBoard> banner = [
    BannerDashBoard(
        imagePath: 'assets/dashboard/bannerImages/1.jpg',
        text: 'Find It, Love It, Buy It.'),
    BannerDashBoard(
        imagePath: 'assets/dashboard/bannerImages/2.png',
        text: 'Stay home and get your daily needs')
  ];
  List<String> bannerText = [
    'Find It, Love It, Buy It.',
    'Stay home and get your daily needs'
  ];

  List<String> sliderImagePath = [
    'assets/dashboard/sliderImages/1.png',
    'assets/dashboard/sliderImages/1.png',
    'assets/dashboard/sliderImages/2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          left: false,
          right: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                ),
                padding: EdgeInsets.all(15),
                child: TextFormField(
                    decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                  hintText: 'Search a product',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Visibility(
                    visible: true,
                    child: Icon(
                      Icons.search,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 1)),
                )),
              ),
              RefreshIndicator(
                onRefresh: refresh,
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                          child: CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                        ),
                        items: banner
                            .map((item) => Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: [
                                      Center(
                                          child: Image.asset(
                                        item.imagePath,
                                        fit: BoxFit.cover,
                                        height: 200,
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.text,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(5)),
                                                child: Text(
                                                  'Order Now',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      )),
                      Container(
                          child: CarouselSlider(
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                        ),
                        items: sliderImagePath
                            .map((item) => Container(
                                  child: Center(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      item,
                                      fit: BoxFit.fitWidth,
                                      height: 200,
                                    ),
                                  )),
                                ))
                            .toList(),
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Categories',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      errorCat != "" ? Text(
                        errorCat,
                        style: TextStyle(color: Colors.red),
                      ) : Container(),
                      isCatLoading ? Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator(),),
                      ) :
                      Container(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Categories(category: categories[index].id, categoryName: categories[index].name,),
                                    ));
                              },
                              child: Container(
                                margin: EdgeInsets.all(4),
                                width: 180,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Image.network(
                                        categories[index].image,
                                        width: MediaQuery.of(context).size.width * 0.36,
                                      )
                                    ),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        categories[index].name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: MyColors.SecondaryColor,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Featured Products',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeaturedScreen()));
                            },
                            child: Text(
                              'View all',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                      errorFeat != "" ? Text(
                        errorFeat,
                        style: TextStyle(color: Colors.red),
                      ) : Container(),
                      isFeatLoading ? Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator(),),
                      ) : 
                      HomeProductCard(
                        items: featuredProducts,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Top Deals',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TopScreen()));
                            },
                            child: Text(
                              'View all',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                      errorTop != "" ? Text(
                        errorTop,
                        style: TextStyle(color: Colors.red),
                      ) : Container(),
                      isTopLoading ? Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator(),),
                      ) :
                      HomeProductCard(
                        items: topProducts,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'More Deals',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllScreen()));
                            },
                            child: Text(
                              'View all',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                      errorAll != "" ? Text(
                        errorAll,
                        style: TextStyle(color: Colors.red),
                      ) : Container(),
                      isAllLoading ? Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator(),),
                      ) :
                      HomeProductCard(
                        items: allProducts,
                      ),
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
