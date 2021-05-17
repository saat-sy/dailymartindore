import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/bottomnav/fav.dart';
import 'package:frontend/screens/bottomnav/home.dart';
import 'package:frontend/screens/bottomnav/profile.dart';
import 'package:frontend/screens/bottomnav/search.dart';

import 'cart.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedPage = 0;
  final _pageOption = [Home(), Search(), Cart(), Profile(), Favorite()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOption[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedPage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              backgroundColor: MyColors.PrimaryColor
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: 'Search',
              backgroundColor: MyColors.PrimaryColor
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bag),
              label: 'My Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), 
              label: 'Wish List',
            ),
          ],
          onTap: (index) {
            setState(() {
              selectedPage = index;
            }
          );
        }
      ),
    );
  }
}