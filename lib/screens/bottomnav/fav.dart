import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/favorites_model.dart';
import 'package:frontend/services/favorites_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  FavoriteService service = FavoriteService();
  APIResponse<List<FavoritesModel>> _apiResponse;
  bool isLoading = true;
  String error;
  bool _recordFound = false;

  List<FavoritesModel> favorites;

  getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponse = await service.getFavorites(id);

    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
        isLoading = false;
      });
    } else {
      print('YES');
      favorites = _apiResponse.data;
      setState(() {
        isLoading = false;
        _recordFound = true;
      });
    }
  }

  APIResponse<bool> _apiResponseRemove;

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 55, width: 55, child: CircularProgressIndicator()),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  removeFavorites(String itemID) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponseRemove = await service.removeFavorites(id, itemID);

    if (_apiResponseRemove.error) {
      setState(() {
        error = _apiResponseRemove.errorMessage;
      });
    }
    Navigator.pop(context);
  }

  @override
  initState() {
    getFavorites();
    super.initState();
  }

  Future<void> refresh() async {
    getFavorites();
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
        title: Text(
          'Favorites',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : !_recordFound
                ? Center(
                    child: Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/empty_favorites.png",
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            Text('You have no favorites yet',
                                style: TextStyle(fontSize: 23))
                          ]),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text(
                                      "Are you sure you wish to delete this product from your favorites?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("DELETE")),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("CANCEL"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (_) {
                            setState(() {
                              removeFavorites(favorites[index].id);
                              favorites.removeAt(index);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.network(
                                      favorites[index].imagePath,
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '₹' + favorites[index].oldPrice,
                                              style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontSize: 14,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              '₹' + favorites[index].price,
                                              style: TextStyle(
                                                color: MyColors.PrimaryColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            favorites[index].discount != null
                                                ? Container(
                                                    padding: EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: MyColors
                                                                .PrimaryColor
                                                            .withOpacity(0.15)),
                                                    child: Center(
                                                      child: Text(
                                                        favorites[index]
                                                                .discount +
                                                            '% OFF',
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .PrimaryColor,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          favorites[index].title,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Text(
                                            favorites[index].description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        RatingBarIndicator(
                                          rating:
                                              favorites[index].rating != null
                                                  ? double.parse(
                                                      favorites[index].rating)
                                                  : 0,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 13.0,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: MyColors.PrimaryColor.withOpacity(
                                          0.2),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.shopping_bag_outlined,
                                      color: MyColors.PrimaryColor,
                                      size: 22,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          background: Container(
                            color: Colors.red,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                CupertinoIcons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
