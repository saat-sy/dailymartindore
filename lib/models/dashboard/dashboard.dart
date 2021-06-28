import 'package:frontend/models/dashboard/banner_images.dart';
import 'package:frontend/models/products/all.dart';
import 'package:frontend/models/products/categories_model.dart';
import 'package:frontend/models/products/featured.dart';
import 'package:frontend/models/products/top.dart';

class DashboardModel {
  List<FeaturedProducts> featuredProducts;
  List<TopProducts> topProducts;
  List<AllProducts> onSaleProducts;
  List<CategoriesModel> categories;
  List<BannerDashBoard> banner;
  List<String> slider;

  DashboardModel({
    this.featuredProducts,
    this.banner,
    this.categories,
    this.onSaleProducts,
    this.slider,
    this.topProducts
  });
}
