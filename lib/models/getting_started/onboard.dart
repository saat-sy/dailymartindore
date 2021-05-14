import 'package:flutter/widgets.dart';

class OnBoardModel {
  String imagePath;
  String title;
  String description;

  OnBoardModel({this.imagePath, this.title, this.description});

  void setImageAssetPath(String imagePath) {
    this.imagePath = imagePath;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String description) {
    this.description = description;
  }

  String getImageAssetPath() {
    return imagePath;
  }

  String getTitle() {
    return title;
  }

  String getDescription() {
    return description;
  }
}

List<OnBoardModel> getSlides() {
  List<OnBoardModel> slides = new List<OnBoardModel>();

  OnBoardModel onBoardModel = new OnBoardModel();

  //1

  onBoardModel.setImageAssetPath('assets/images/onboard1.jpg');
  onBoardModel.setTitle("Welcome to \nCarter Grocery Application!");
  onBoardModel.setDescription("Carter online grocery store is the No.1 grocery application in the world");
  slides.add(onBoardModel);

  //2
  onBoardModel = new OnBoardModel();

  onBoardModel.setImageAssetPath('assets/images/onboard2.jpg');
  onBoardModel.setTitle("Best quality \ngrocery at your \ndoorstep!");
  onBoardModel.setDescription("Carter online grocery store where we deliver everything on time.");
  slides.add(onBoardModel);

  //3
  onBoardModel = new OnBoardModel();

  onBoardModel.setImageAssetPath('assets/images/onboard3.jpg');
  onBoardModel.setTitle("Peace of mind same day delivery guaranteed!");
  onBoardModel.setDescription("We dispatch all the orders within two hours of the order being placed");
  slides.add(onBoardModel);

  //4
  onBoardModel = new OnBoardModel();

  onBoardModel.setImageAssetPath('assets/images/onboard4.jpg');
  onBoardModel.setTitle("Big savings with seasonal discounts on all products.");
  onBoardModel.setDescription("We belive in providing best competitive prices to all our customers.");
  slides.add(onBoardModel);

  return slides;
}
