import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/about_us/aboutUs.dart';
import 'package:frontend/screens/about_us/abt_us.dart';
import 'package:frontend/screens/about_us/faq.dart';
import 'package:frontend/screens/about_us/terms.dart';
import 'package:frontend/screens/address/address.dart';
import 'package:frontend/screens/authenticate/change_password.dart';
import 'package:frontend/screens/authenticate/login.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/screens/order/myOrder.dart';
import 'package:frontend/screens/products/all_categories.dart';
import 'package:frontend/screens/profile/notifications.dart';
import 'package:frontend/screens/profile/profile_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String currentName = '';
  String currentEmail = '';
  String currentPhone = '';

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        currentName = prefs.getString(PrefConstants.name).toString() ?? 'NAme?';
        currentEmail =
            prefs.getString(PrefConstants.email).toString() ?? 'EMail?';
        currentPhone =
            prefs.getString(PrefConstants.phone).toString() ?? 'PHone?';
      });
  }

  @override
  initState() {
    getData();
    super.initState();
  }

  Future<void> removeSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefConstants.email, "");
    await prefs.setString(PrefConstants.name, "");
    await prefs.setString(PrefConstants.phone, "");
    await prefs.setString(PrefConstants.inCart, "");
    await prefs.setString(PrefConstants.inFav, "");
    await prefs.setInt(PrefConstants.id, -1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Container(
            height: 25 + (MediaQuery.of(context).size.width * 0.15),
            color: Colors.white,
          ),
          Center(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    ClipOval(
                      child: Image(
                        image: AssetImage('assets/images/profile.png'),
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      currentName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      currentEmail,
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      currentPhone,
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.person_outline_outlined,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('About Me'),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyOrder()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('My Orders'),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => BottomNav(
                                  index: 3,
                                ),
                              ),
                              (route) => false,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.favorite_border_outlined,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('My Wish List'),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Notifications()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.notifications_outlined,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Notifications'),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Address()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.pin_drop_outlined,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('My Address'),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllCategories()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.category_outlined,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Categories'),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutUsScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.info_outline,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('About us'),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TermsAndConditions()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      MdiIcons.fileDocumentOutline,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Terms & Conditions'),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => FAQ()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      MdiIcons.frequentlyAskedQuestions,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('FAQ'),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePassword()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      CupertinoIcons.pencil,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Change Password'),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            removeSharedPrefs();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.power_settings_new,
                                      color: MyColors.PrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Sign Out'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
