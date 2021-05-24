import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/all.dart';
import 'package:frontend/models/products/categories_model.dart';
import 'package:frontend/models/products/featured.dart';
import 'package:frontend/models/products/store_list_model.dart';
import 'package:frontend/models/products/top.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/screens/products/allScreen.dart';
import 'package:frontend/screens/products/categories.dart';
import 'package:frontend/screens/products/featuredScreen.dart';
import 'package:frontend/screens/products/topScreen.dart';
import 'package:frontend/screens/profile/notifications.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';

import 'package:frontend/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  APIResponse<List<StoreListModel>> _apiResponseStore;

  bool isFeatLoading = true;
  bool isTopLoading = true;
  bool isAllLoading = true;
  bool isCatLoading = true;
  bool isStoreLoading = true;
  String errorFeat = '';
  String errorTop = '';
  String errorAll = '';
  String errorCat = '';
  String errorStore = '';

  bool isStorePresent = true;

  List<FeaturedProducts> featuredProducts;
  List<TopProducts> topProducts;
  List<AllProducts> allProducts;
  List<CategoriesModel> categories;
  List<StoreListModel> stores;

  getProducts() async {
    //GET STORES
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

      if (storeAddress == '')
        for (final store in stores) {
          if (store.address == storeAddress) _selectedStore = store.address;
        }
      else
        _selectedStore = stores[0].address;

      if (mounted)
        setState(() {
          isStoreLoading = false;
        });
      if (stores == null)
        setState(() {
          isStorePresent = false;
        });
    }

    //GET FEATURED PRODUCTS
    _apiResponseFeat = await service.getFeaturedProducts();
    if (_apiResponseFeat.error) {
      setState(() {
        errorFeat = _apiResponseFeat.errorMessage;
      });
    } else {
      featuredProducts = _apiResponseFeat.data;
      if (mounted)
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
      if (mounted)
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
      if (mounted)
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
      if (mounted)
        setState(() {
          isCatLoading = false;
        });
    }
  }

  String _selectedStore;

  getStoreDialog() {
    final items = <String>[];
    for (final store in stores) {
      String data = store.address.toString();
      items.add(data);
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
                    setState(() {
                      _selectedStore = value;
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(
                      child: Container(
                        width: 230,
                        child: Text(e)
                      ),
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
                  await changeStore(_selectedStore);
                  Navigator.pop(context);
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

  Future<void> changeStore(String address) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefConstants.storeDefaultAddress, address);
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
                        Row(
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
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNav(
                                      index: 1,
                                    )));
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
                                'Search a Product',
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 16),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              RefreshIndicator(
                onRefresh: refresh,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      //mainAxisSize: MainAxisSize.max,
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
                                            BorderRadius.circular(10)),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                          BorderRadius.circular(
                                                              5)),
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
                        errorCat != ""
                            ? Text(
                                errorCat,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        isCatLoading
                            ? Container(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Container(
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
                                              builder: (context) => Categories(
                                                category: categories[index].id,
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.36,
                                                )),
                                            Container(
                                              alignment: Alignment.topCenter,
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                categories[index].name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        MyColors.SecondaryColor,
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
                        errorFeat != ""
                            ? Text(
                                errorFeat,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        isFeatLoading
                            ? Container(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : HomeProductCard(
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
                        errorTop != ""
                            ? Text(
                                errorTop,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        isTopLoading
                            ? Container(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : HomeProductCard(
                                items: topProducts,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'On Sale Products',
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
                        errorAll != ""
                            ? Text(
                                errorAll,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        isAllLoading
                            ? Container(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : HomeProductCard(
                                items: allProducts,
                              ),
                        SizedBox(
                          height: 25,
                        )
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
