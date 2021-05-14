import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/bottomnav/fav.dart';
import 'package:frontend/screens/bottomnav/home.dart';
import 'package:frontend/screens/bottomnav/profile.dart';

import 'cart.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedPage = 0;
  final _pageOption = [Home(), Favorite(), Profile(), Cart()];

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
              icon: Icon(Icons.favorite_outline), 
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'Shopping Cart',
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

// TabItem(icon: Icons.home_outlined),
//           TabItem(icon: Icons.favorite_outline),
//           TabItem(icon: Icons.person_outline_outlined),
//           TabItem(icon: Icons.shopping_bag_outlined),