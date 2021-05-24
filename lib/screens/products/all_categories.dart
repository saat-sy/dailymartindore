import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/categories_model.dart';
import 'package:frontend/screens/products/categories.dart';
import 'package:frontend/services/products_service.dart';

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
      setState(() {
        error = _apiResponseCategory.errorMessage;
        print(error);
      });
    } else {
      categories = _apiResponseCategory.data;
      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }

  @override
  initState() {
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
        title: Text('Categories'),
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
                  CategoryExpandableWidget(categories[index], context),
              itemCount: categories.length,
            ),
    );
  }
}

class CategoryExpandableWidget extends StatelessWidget {
  final CategoriesModel category;
  final BuildContext context;

  CategoryExpandableWidget(this.category, this.context);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey<CategoriesModel>(category),
      title: Text(category.name,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
      children: category.subCategories.length != null
          ? category.subCategories.map<Widget>((club) => showSub(club)).toList()
          : Container(),
    );
  }

  showSub(SubCategoriesModel subCategory) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Categories()));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: new ListTile(
          title: new Text(
            subCategory.name,
            style: new TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
