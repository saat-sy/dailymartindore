import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/dashboard/brands.dart';
import 'package:frontend/screens/bottomnav/bottomnav_anonymous.dart';
import 'package:frontend/services/search_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bottomnav.dart';

class Brand extends StatefulWidget {
  @override
  _BrandState createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  SearchService service = SearchService();
  APIResponse<List<BrandModel>> _apiResponse;

  List<BrandModel> brands;

  bool isLoading = true;

  List<bool> selectedBool;

  getBrands() async {
    _apiResponse = await service.getBrand();
    if (_apiResponse.error) {
      print(_apiResponse.errorMessage);
    } else {
      brands = _apiResponse.data;
      selectedBool = List<bool>.filled(brands.length, false, growable: true);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getBrands();
    checkLoginStatus();
    super.initState();
  }

  bool isLoggedIn = true;

  checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(PrefConstants.name).toString() ?? "";
    print('name:' + name);
    if (name == "") {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Brand'),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      itemCount: brands.length,
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedBool[index] = !selectedBool[index];
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Stack(
                              children: [
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      brands[index].image,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                selectedBool[index]
                                    ? Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          Icons.check_circle_outline,
                                          color: MyColors.SecondaryColor,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        );
                      },
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: Center(
                                child: Text(
                                  'Discard',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              String selectedBrands = '';
                              for (int i = 0; i < brands.length; i++) {
                                if (selectedBool[i]) {
                                  if (selectedBrands.isNotEmpty)
                                    selectedBrands += ',';
                                  selectedBrands += brands[i].id;
                                }
                              }
                              isLoggedIn
                                  ? Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BottomNav(
                                          index: 1,
                                          brands: selectedBrands,
                                        ),
                                      ),
                                      (route) => false,
                                    )
                                  : Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BottomNavAnonymous(
                                          index: 1,
                                          brands: selectedBrands,
                                        ),
                                      ),
                                      (route) => false,
                                    );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: MyColors.PrimaryColor),
                              child: Center(
                                child: Text(
                                  'Apply',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
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
  }
}
