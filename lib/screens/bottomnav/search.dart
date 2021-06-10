import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/search_model.dart';
import 'package:frontend/screens/bottomnav/search_assets/brand.dart';
import 'package:frontend/screens/products/all_categories.dart';
import 'package:frontend/services/search_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  final String minPrice;
  final String maxPrice;
  final String color;
  final String size;
  final String ratings;
  final String discount;
  final String searchTerm;
  bool filter = false;
  bool fromBottomNav = false;

  Search(
      {this.color,
      this.discount,
      this.maxPrice,
      this.minPrice,
      this.ratings,
      this.searchTerm,
      this.filter,
      this.fromBottomNav = false,
      this.size});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SearchService service = SearchService();

  APIResponse<List<SearchModel>> _apiResponse;

  bool isLoading = true;

  String error = '';

  List<SearchModel> searchResults;

  load(String searchTerm) async {
    isLoading = true;
    searchResults = [];
    _apiResponse = await service.getSearchResults(
        searchTerm,
        sortText,
        widget.minPrice,
        widget.maxPrice,
        widget.color,
        widget.discount,
        widget.size,
        widget.ratings);

    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
        });
    } else {
      searchResults = _apiResponse.data;
      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }

  bool search = true;

  var focusNode = FocusNode();

  final searchController = TextEditingController();

  @override
  initState() {
    load('');
    print('ejvrnjinwr ' + widget.fromBottomNav.toString());
    if (!widget.fromBottomNav) {
      print('not from bottomNav');
    } else {
      Future.delayed(Duration.zero, () {
        FocusScope.of(context).requestFocus(focusNode);
        focusNode.requestFocus();
      });
    }
    super.initState();
  }

  List<String> sortOptions = [
    'Default',
    'Popularity',
    'Latest',
    'Price: Low to High',
    'Price: High to Low',
    'Alphabetical, A-Z',
    'Alphabetical, Z-A'
  ];

  String sortText = 'Default';
  String searchTerm = '';

  String minPriceFinal = '';
  String maxPriceFinal = '';
  String ratingsFinal = '';
  String colorFinal = '';
  String sizeFinal = '';
  String discountFinal = '';

  List<bool> size = [
    false,
    false,
    false,
    false,
  ];

  List<bool> color = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  List<bool> discount = [false, false, false, false, false];

  List<bool> ratings = [
    false,
    false,
    false,
    false,
  ];

  List<String> sizeText = [
    'Extra Large',
    'Large',
    'Medium',
    'Small',
  ];

  List<String> colorText = [
    'Black',
    'Blue',
    'Brown',
    'Green',
    'Orange',
    'White',
    'Red',
    'Yellow',
  ];

  List<String> discountText = [
    'Less than < 10%',
    '10% to 20%',
    '20% to 40%',
    '40% to 60%',
    '60% to 90%'
  ];

  List<String> ratingsText = [
    '4★ & above',
    '3★ & above',
    '2★ & above',
    '1★ & above',
  ];

  List<String> sizeID = [
    '6',
    '3',
    '4',
    '5',
  ];

  List<String> colorID = [
    '9',
    '2',
    '6',
    '4',
    '7',
    '3',
    '5',
    '8',
  ];

  List<String> discountID = ['1', '2', '3', '4', '5'];

  List<String> ratingsID = [
    '4',
    '3',
    '2',
    '1',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
            ),
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                    controller: searchController,
                    focusNode: focusNode,
                    onSubmitted: (value) {
                      if (mounted)
                        setState(() {
                          if (value != '') {
                            if (!search) search = true;
                            searchTerm = value;
                            load(value);
                          }
                        });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      hintText: 'Search products by title',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Visibility(
                        visible: true,
                        child: Icon(
                          Icons.search,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchController.text = '';
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1)),
                    )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                        child: Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 30),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    'Shop by Price',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey.shade300,
                                                        offset:
                                                            Offset(0.0, 0.0),
                                                        blurRadius: 4.0,
                                                      ),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .numberWithOptions(
                                                                      decimal:
                                                                          true),
                                                          cursorColor: MyColors
                                                              .PrimaryColor,
                                                          onChanged: (val) =>
                                                              minPriceFinal =
                                                                  val,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    vertical:
                                                                        0.0,
                                                                    horizontal:
                                                                        10.0),
                                                            hintText: 'Min',
                                                            fillColor:
                                                                Colors.white,
                                                            filled: true,
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500,
                                                                    width:
                                                                        1.0)),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500,
                                                                    width:
                                                                        1.0)),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .numberWithOptions(
                                                                      decimal:
                                                                          true),
                                                          cursorColor: MyColors
                                                              .PrimaryColor,
                                                          onChanged: (val) =>
                                                              maxPriceFinal =
                                                                  val,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    vertical:
                                                                        0.0,
                                                                    horizontal:
                                                                        10.0),
                                                            hintText: 'Max',
                                                            fillColor:
                                                                Colors.white,
                                                            filled: true,
                                                            enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500,
                                                                    width:
                                                                        1.0)),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500,
                                                                    width:
                                                                        1.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    'Shop by Size',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey.shade300,
                                                          offset:
                                                              Offset(0.0, 0.0),
                                                          blurRadius: 4.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Container(
                                                      height: 230,
                                                      child: ListView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: size.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CheckboxListTile(
                                                            title: Text(
                                                                sizeText[
                                                                    index]),
                                                            value: size[index],
                                                            onChanged:
                                                                (newValue) {
                                                              if (mounted)
                                                                setState(() {
                                                                  size[index] =
                                                                      newValue;
                                                                });
                                                            },
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .trailing,
                                                          );
                                                        },
                                                      ),
                                                    )),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    'Shop by Color',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Container(
                                                    height: 460,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey.shade300,
                                                          offset:
                                                              Offset(0.0, 0.0),
                                                          blurRadius: 4.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Container(
                                                      child: ListView.builder(
                                                        itemCount: color.length,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CheckboxListTile(
                                                            title: Text(
                                                                colorText[
                                                                    index]),
                                                            value: color[index],
                                                            onChanged:
                                                                (newValue) {
                                                              if (mounted)
                                                                setState(() {
                                                                  color[index] =
                                                                      newValue;
                                                                });
                                                            },
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .trailing,
                                                          );
                                                        },
                                                      ),
                                                    )),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    'Shop by Discount',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Container(
                                                    height: 287.5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey.shade300,
                                                          offset:
                                                              Offset(0.0, 0.0),
                                                          blurRadius: 4.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Container(
                                                      child: ListView.builder(
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            discount.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CheckboxListTile(
                                                            title: Text(
                                                                discountText[
                                                                    index]),
                                                            value:
                                                                discount[index],
                                                            onChanged:
                                                                (newValue) {
                                                              if (mounted)
                                                                setState(() {
                                                                  discount[
                                                                          index] =
                                                                      newValue;
                                                                });
                                                            },
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .trailing,
                                                          );
                                                        },
                                                      ),
                                                    )),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    'Customers Ratings',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey.shade300,
                                                          offset:
                                                              Offset(0.0, 0.0),
                                                          blurRadius: 4.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Container(
                                                      height: 230,
                                                      child: ListView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            ratings.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CheckboxListTile(
                                                            title: Text(
                                                                ratingsText[
                                                                    index]),
                                                            value:
                                                                ratings[index],
                                                            onChanged:
                                                                (newValue) {
                                                              if (mounted)
                                                                setState(() {
                                                                  ratings[index] =
                                                                      newValue;
                                                                });
                                                            },
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .trailing,
                                                          );
                                                        },
                                                      ),
                                                    )),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Brand()));
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Brand',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 18,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 60,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height: 60,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade400,
                                                  offset: Offset(0.0, -0.5),
                                                  blurRadius: 3.0,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1)),
                                                    child: Center(
                                                      child: Text(
                                                        'Discard',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    size
                                                        .asMap()
                                                        .forEach((key, value) {
                                                      if (value) {
                                                        if (sizeFinal != '')
                                                          sizeFinal +=
                                                              ',' + sizeID[key];
                                                        else
                                                          sizeFinal +=
                                                              sizeID[key];
                                                      }
                                                    });

                                                    color
                                                        .asMap()
                                                        .forEach((key, value) {
                                                      if (value) {
                                                        if (colorFinal != '')
                                                          colorFinal += ',' +
                                                              colorID[key];
                                                        else
                                                          colorFinal +=
                                                              colorID[key];
                                                      }
                                                    });

                                                    discount
                                                        .asMap()
                                                        .forEach((key, value) {
                                                      if (value) {
                                                        if (discountFinal != '')
                                                          discountFinal += ',' +
                                                              discountID[key];
                                                        else
                                                          discountFinal +=
                                                              discountID[key];
                                                      }
                                                    });

                                                    ratings
                                                        .asMap()
                                                        .forEach((key, value) {
                                                      if (value) {
                                                        if (ratingsFinal != '')
                                                          ratingsFinal += ',' +
                                                              ratingsID[key];
                                                        else
                                                          ratingsFinal +=
                                                              ratingsID[key];
                                                      }
                                                    });

                                                    load(searchTerm);

                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: MyColors
                                                            .PrimaryColor),
                                                    child: Center(
                                                      child: Text(
                                                        'Apply',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                                  });
                                });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    MdiIcons.filterVariant,
                                    color: Colors.grey.shade700,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Filter',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    topLeft: Radius.circular(25),
                                  ),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          width: 40,
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Sort By',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListView.builder(
                                              itemCount: sortOptions.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    if (mounted)
                                                      setState(() {
                                                        sortText =
                                                            sortOptions[index];
                                                        load(searchTerm);
                                                      });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Text(
                                                          sortOptions[index])),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    MdiIcons.sort,
                                    color: Colors.grey.shade700,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    sortText,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              )),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllCategories()));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.menu,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                            ],
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          !search
              ? Container()
              : Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : searchResults.length != 0
                          ? ProductCard(
                              items: searchResults,
                            )
                          : Center(
                              child: Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/empty_search.png",
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                      ),
                                      Text('Sorry! No product found',
                                          style: TextStyle(fontSize: 23))
                                    ]),
                              ),
                            )),
        ],
      ),
    ));
  }
}
