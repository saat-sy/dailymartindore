import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/dashboard/banner_images.dart';
import 'package:frontend/models/dashboard/dashboard.dart';
import 'package:frontend/models/products/all.dart';
import 'package:frontend/models/products/categories_model.dart';
import 'package:frontend/models/products/featured.dart';
import 'package:frontend/models/products/product.dart';
import 'package:frontend/models/products/store_list_model.dart';
import 'package:frontend/models/products/top.dart';
import 'package:frontend/screens/authenticate/login.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/screens/bottomnav/bottomnav_anonymous.dart';
import 'package:frontend/screens/products/allScreen.dart';
import 'package:frontend/screens/products/all_categories.dart';
import 'package:frontend/screens/products/categories.dart';
import 'package:frontend/screens/products/featuredScreen.dart';
import 'package:frontend/screens/products/topScreen.dart';
import 'package:frontend/screens/profile/notifications.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';

import 'package:frontend/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProductService service = ProductService();
  APIResponse<List<StoreListModel>> _apiResponseStore;

  APIResponse<DashboardModel> _apiResponseDashboard;

  bool isDashLoading = true;
  bool isStoreLoading = true;
  bool isRecentLoading = true;
  String errorDash = '';
  String errorStore = '';
  String errorRecent = '';

  bool isStorePresent = true;

  List<FeaturedProducts> featuredProducts;
  List<FeaturedProducts> recentProducts = [];
  List<TopProducts> topProducts;
  List<AllProducts> allProducts;
  List<CategoriesModel> categories;
  List<StoreListModel> stores;
  List<BannerDashBoard> banner = [];
  List<String> sliderImagePath = [];

  getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    String fav = prefs.getString(PrefConstants.inFav) ?? "";
    String cart = prefs.getString(PrefConstants.inCart) ?? "";
    String recent = prefs.getString(PrefConstants.recentProducts) ?? "";
    if (recent == "") {
      setState(() {
        isRecentLoading = false;
      });
    }

    //STORES
    _apiResponseStore = await service.getStoreList();
    if (_apiResponseStore.error) {
      if (mounted)
        setState(() {
          errorStore = _apiResponseStore.errorMessage;
        });
    } else {
      stores = _apiResponseStore.data;

      final prefs = await SharedPreferences.getInstance();
      String storeAddress =
          prefs.getString(PrefConstants.storeDefaultAddress).toString() ?? '';

      if (storeAddress != '')
        for (final store in stores) {
          if (store.address == storeAddress) {
            _selectedStore = store.address;
            _selectedStoreID = store.id;
          }
        }
      else {
        _selectedStore = stores[0].address;
        _selectedStoreID = stores[0].id;
      }

      if (mounted)
        setState(() {
          isStoreLoading = false;
        });
      if (stores == null) if (mounted)
        setState(() {
          isStorePresent = false;
        });
    }

    //DASHBOARD
    _apiResponseDashboard = await service.getDashboard();
    if (_apiResponseDashboard.error) {
      print(_apiResponseDashboard.errorMessage);
    } else {
      //  FEATURED
      featuredProducts = _apiResponseDashboard.data.featuredProducts;
      for (int i = 0; i < featuredProducts.length; i++) {
        fav.split(',').forEach((element) {
          if (element == featuredProducts[i].id)
            featuredProducts[i].inFav = true;
        });
        cart.split(',').forEach((element) {
          if (element == featuredProducts[i].id)
            featuredProducts[i].inCart = true;
        });
      }
      //  TOP
      topProducts = _apiResponseDashboard.data.topProducts;
      for (int i = 0; i < topProducts.length; i++) {
        fav.split(',').forEach((element) {
          if (element == topProducts[i].id) topProducts[i].inFav = true;
        });
        cart.split(',').forEach((element) {
          if (element == topProducts[i].id) topProducts[i].inCart = true;
        });
      }
      //  ALL
      allProducts = _apiResponseDashboard.data.onSaleProducts;
      for (int i = 0; i < allProducts.length; i++) {
        fav.split(',').forEach((element) {
          if (element == allProducts[i].id) allProducts[i].inFav = true;
        });
        cart.split(',').forEach((element) {
          if (element == allProducts[i].id) allProducts[i].inCart = true;
        });
      }
      //  CATEGORIES
      categories = _apiResponseDashboard.data.categories;
      //  BANNER
      banner = _apiResponseDashboard.data.banner;
      //  SLIDER
      sliderImagePath = _apiResponseDashboard.data.slider;
      if (mounted)
        setState(() {
          isDashLoading = false;
        });
    }

    //GET RECENT PRODUCTS
    if (recent != "") {
      for (final r in recent.split(',')) {
        APIResponse<ProductModel> _apiProduct;
        _apiProduct = await service.getProductByID(r);
        if (!_apiProduct.error) {
          ProductModel p = _apiProduct.data;
          final rp = FeaturedProducts(
            id: p.id,
            imagePath: p.image,
            title: p.title,
            description: p.description,
            isVeg: p.isVeg,
            discount: p.discount,
            rating: p.rating,
            quantity: p.quantity,
            oldPrice: p.oldPrice,
            newPrice: p.price,
            inFav: p.inFav,
            inCart: p.inCart,
          );
          recentProducts.add(rp);
        }
      }
      for (int i = 0; i < recentProducts.length; i++) {
        fav.split(',').forEach((element) {
          if (element == recentProducts[i].id) recentProducts[i].inFav = true;
        });
        cart.split(',').forEach((element) {
          if (element == recentProducts[i].id) recentProducts[i].inCart = true;
        });
      }
    }
    if (mounted)
      setState(() {
        isRecentLoading = false;
      });
  }

  String _selectedStore;
  String _selectedStoreID;

  getStoreDialog() {
    final items = <String>[];
    final itemIDs = <String>[];
    for (final store in stores) {
      String data = store.address.toString();
      items.add(data);
    }
    for (final store in stores) {
      String data = store.id.toString();
      itemIDs.add(data);
    }
    AlertDialog alert = AlertDialog(
      content: Container(
        child: StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: DropdownButton<String>(
                  value: _selectedStore,
                  onChanged: (String value) {
                    if (mounted)
                      setState(() {
                        _selectedStore = value;
                        _selectedStoreID = itemIDs[items.indexOf(value)];
                      });
                  },
                  items: items.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(
                      child: Container(width: 230, child: Text(e)),
                      value: e,
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SubmitButton(
                text: 'Submit',
                onPress: () async {
                  await changeStoreAndID(_selectedStore, _selectedStoreID);
                  Navigator.pop(context);
                  if (isLoggedIn) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => BottomNav(),
                      ),
                      (route) => false,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => BottomNavAnonymous(),
                      ),
                      (route) => false,
                    );
                  }
                },
              )
            ],
          );
        }),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> changeStoreAndID(String address, String id) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefConstants.storeDefaultAddress, address);
    await prefs.setString(PrefConstants.storeID, id);
  }

  Future<void> refresh() async {
    if (mounted)
      setState(() {
        isDashLoading = true;
        isStoreLoading = true;
        errorDash = '';
        errorStore = '';

        featuredProducts = [];
        topProducts = [];
        allProducts = [];
        categories = [];
        stores = [];
      });
    await getProducts();
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
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Image.asset(
                            'assets/images/icon2.png',
                            width: MediaQuery.of(context).size.width * 0.3,
                          ),
                        ),
                        isLoggedIn
                            ? Row(
                                children: [
                                  isStorePresent
                                      ? IconButton(
                                          icon: Icon(CupertinoIcons.location,
                                              color: Colors.grey.shade700),
                                          onPressed: () {
                                            getStoreDialog();
                                          })
                                      : Container(),
                                  IconButton(
                                      icon: Icon(CupertinoIcons.bell,
                                          color: Colors.grey.shade700),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Notifications()));
                                      })
                                ],
                              )
                            : IconButton(
                                icon: Icon(CupertinoIcons.person,
                                    color: Colors.grey.shade700),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                })
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => BottomNav(
                              index: 1,
                              search: true,
                            ),
                          ),
                          (route) => false,
                        );
                      },
                      child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white),
                          child: Row(
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 10),
                              Text(
                                'Search products by title',
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 16),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              isDashLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ))
                  : errorDash != ''
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                              child: Text(
                            errorDash,
                            style: TextStyle(color: Colors.redAccent),
                          )))
                      : RefreshIndicator(
                          onRefresh: refresh,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Stack(
                                                children: [
                                                  Center(
                                                      child: Image.network(
                                                    item.imagePath,
                                                    fit: BoxFit.cover,
                                                    height: 200,
                                                  )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item.text,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    BottomNav(
                                                                  index: 1,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Text(
                                                              'Order Now',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      child: CarouselSlider(
                                    options: CarouselOptions(
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                    ),
                                    items: sliderImagePath
                                        .map((item) => GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        BottomNav(
                                                      index: 1,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                child: Center(
                                                    child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.network(
                                                    item,
                                                    fit: BoxFit.fitWidth,
                                                    height: 200,
                                                  ),
                                                )),
                                              ),
                                            ))
                                        .toList(),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Categories',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AllCategories()));
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
                                  ),
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
                                                      Categories(
                                                    category:
                                                        categories[index].id,
                                                    categoryName:
                                                        categories[index].name,
                                                  ),
                                                ));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(4),
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Image.network(
                                                      categories[index].image,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.36,
                                                    )),
                                                Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    categories[index].name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: MyColors
                                                            .SecondaryColor,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Featured Products',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FeaturedScreen()));
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
                                  featuredProducts.length == 0 ?
                                  Container(
                                    height: 250,
                                    child: Center(
                                      child: Text(
                                        "No Product Found",
                                        style: TextStyle(
                                          color: Colors.redAccent
                                        )
                                      )
                                    )
                                  ) :
                                  HomeProductCard(
                                    items: featuredProducts,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Top Deals',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TopScreen()));
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
                                  topProducts.length == 0 ?
                                  Container(
                                    height: 250,
                                    child: Center(
                                      child: Text(
                                        "No Product Found",
                                        style: TextStyle(
                                          color: Colors.redAccent
                                        )
                                      )
                                    )
                                  ) :
                                  HomeProductCard(
                                    items: topProducts,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'On Sale Products',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllScreen()));
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
                                  allProducts.length == 0 ?
                                  Container(
                                    height: 250,
                                    child: Center(
                                      child: Text(
                                        "No Product Found",
                                        style: TextStyle(
                                          color: Colors.redAccent
                                        )
                                      )
                                    )
                                  ) :
                                  HomeProductCard(
                                    items: allProducts,
                                  ),
                                  isRecentLoading
                                      ? Container(
                                          height: 335.3,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : recentProducts.length != 0
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Text(
                                                    'Recent Products',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                HomeProductCard(
                                                  items: recentProducts,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                ],
                              ),
                            ),
                          ),
                        )
            ],
          ),
        )),
      ],
    );
  }
}
