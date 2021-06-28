import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/categories_model.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/screens/bottomnav/bottomnav_anonymous.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainCategory {
  String category;
  List<SubCategory> subcategories;
  MainCategory(this.category, this.subcategories);
}

class SubCategory {
  String subCategory;

  SubCategory(this.subCategory);
}

class AllCategories extends StatefulWidget {
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  ProductService service = ProductService();
  APIResponse<List<CategoriesModel>> _apiResponseCategory;
  bool isLoading = true;
  String error = '';
  List<CategoriesModel> categories;

  getCategories() async {
    _apiResponseCategory = await service.getCategories();
    if (_apiResponseCategory.error) {
      if (mounted)
        setState(() {
          error = _apiResponseCategory.errorMessage;
          print(error);
        });
    } else {
      categories = _apiResponseCategory.data;
      if (mounted) if (mounted)
        setState(() {
          isLoading = false;
        });
    }
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
  initState() {
    checkLoginStatus();
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(Strings.ALL_CATEGORIES_APPBAR),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  error != ""
                      ? Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container()
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  CategoryExpandableWidget(
                      categories[index], context, isLoggedIn),
              itemCount: categories.length,
            ),
    );
  }
}

class CategoryExpandableWidget extends StatelessWidget {
  final CategoriesModel category;
  final BuildContext context;
  final bool isLoggedIn;

  CategoryExpandableWidget(this.category, this.context, this.isLoggedIn);

  @override
  Widget build(BuildContext context) {
    return category.subCategories.length == 0
        ? InkWell(
            onTap: () {
              if(isLoggedIn)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNav(
                        searchTerm: category.id + '@' + category.name,
                        index: 1,
                      ),
                    ));
              else
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavAnonymous(
                        searchTerm: category.id + '@' + category.name,
                        index: 1,
                      ),
                    ));
            },
            child: ListTile(
              title: new Text(
                category.name,
                style: new TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
          )
        : ExpansionTile(
            key: PageStorageKey<CategoriesModel>(category),
            title: Text(category.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
            children: category.subCategories
                .map<Widget>((sub) => showSub(sub, isLoggedIn))
                .toList(),
          );
  }

  showSub(SubCategoriesModel subCategory, bool isLoggedIn) {
    return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: subCategory.subSubCategoriesModel.length == 0
            ? InkWell(
                onTap: () {
                  if(isLoggedIn)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNav(
                        searchTerm: subCategory.id + '@' + subCategory.name,
                        index: 1,
                      ),
                    ));
              else
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavAnonymous(
                        searchTerm: subCategory.id + '@' + category.name,
                        index: 1,
                      ),
                    ));
                },
                child: ListTile(
                  title: Text(
                    subCategory.name,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              )
            : ExpansionTile(
                key: PageStorageKey<SubCategoriesModel>(subCategory),
                title: Text(subCategory.name, style: TextStyle(fontSize: 17)),
                children: subCategory.subSubCategoriesModel
                    .map<Widget>((subsub) =>
                        showSubSub(subsub, subCategory.name, subCategory.id, isLoggedIn))
                    .toList(),
              ));
  }

  showSubSub(SubSubCategoriesModel subsubCategory, String name, String id, bool isLoggedIn) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: InkWell(
          onTap: () {
            if(isLoggedIn)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNav(
                        searchTerm: subsubCategory.id + '@' + subsubCategory.name,
                        index: 1,
                      ),
                    ));
              else
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavAnonymous(
                        searchTerm: subsubCategory.id + '@' + subsubCategory.name,
                        index: 1,
                      ),
                    ));
          },
          child: subsubCategory.subSubSubCategoriesModel.length == 0
              ? ListTile(
                  title: Text(
                    subsubCategory.name,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ExpansionTile(
                  key: PageStorageKey<SubSubCategoriesModel>(subsubCategory),
                  title:
                      Text(subsubCategory.name, style: TextStyle(fontSize: 17)),
                  children: subsubCategory.subSubSubCategoriesModel
                      .map<Widget>((subsub) => showSubSubSub(
                          subsub, subsubCategory.name, subsubCategory.id, isLoggedIn))
                      .toList(),
                )),
    );
  }

  showSubSubSub(SubSubSubCategoriesModel subsubsub, String name, String id, bool isLoggedIn) {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: InkWell(
        onTap: () {
          if(isLoggedIn)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNav(
                        searchTerm: subsubsub.id + '@' + subsubsub.name,
                        index: 1,
                      ),
                    ));
              else
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavAnonymous(
                        searchTerm: subsubsub.id + '@' + subsubsub.name,
                        index: 1,
                      ),
                    ));
        },
        child: ListTile(
          title: Text(
            subsubsub.name,
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }
}
