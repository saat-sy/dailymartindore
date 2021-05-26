import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/address/address.dart';
import 'package:frontend/screens/authenticate/login.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/screens/order/myOrder.dart';
import 'package:frontend/screens/products/all_categories.dart';
import 'package:frontend/screens/profile/notifications.dart';
import 'package:frontend/screens/profile/profile_page.dart';
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
    setState(() {
      currentName = prefs.getString(PrefConstants.name).toString() ?? 'NAme?';
      currentEmail = prefs.getString(PrefConstants.email).toString() ?? 'EMail?';
      currentPhone = prefs.getString(PrefConstants.phone).toString() ?? 'PHone?';
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
    await prefs.setInt(PrefConstants.id, -1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Container(
            height: 25 + (MediaQuery.of(context).size.width * 0.28),
            color: Colors.white,
          ),
          Center(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    ClipOval(
                      child: Image(
                        image: AssetImage('assets/images/profile.png'),
                        width: MediaQuery.of(context).size.width * 0.28,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      currentName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
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
                    SizedBox(height: 30),
                  ],
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ProfilePage()));
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
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNav(index: 4,)));
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Address()));
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AllCategories()));
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
                        removeSharedPrefs();
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
