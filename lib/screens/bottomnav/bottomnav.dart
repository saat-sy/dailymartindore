import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/bottomnav/fav.dart';
import 'package:frontend/screens/bottomnav/home.dart';
import 'package:frontend/screens/bottomnav/profile.dart';
import 'package:frontend/screens/bottomnav/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';

class BottomNav extends StatefulWidget {
  final int index;
  final bool search;

  BottomNav({
    this.index,
    this.search = false
  });

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedPage = 0;
  List _pageOption = [];
  bool indexUsed = false;

  int cartItems = 0;

  getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    String cart = prefs.getString(PrefConstants.inCart) ?? "";
    print(cart);
    if (cart != "") if (mounted)
      setState(() {
        cartItems = cart.split(',').length;
      });
  }

  bool fromBtm = false;

  @override
  void initState() {
    getCartItems();
    _pageOption = [Home(), Search(), Cart(), Favorite(), Profile()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!indexUsed) {
      selectedPage = widget.index ?? 0;
      indexUsed = true;
    }
    if (widget.search){
      setState(() {
        fromBtm = true;
      });
    }
    return Scaffold(
      body: SafeArea(
        child: selectedPage == 1
            ? Search(
                fromBottomNav: fromBtm,
              )
            : _pageOption[selectedPage],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedPage,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
                backgroundColor: MyColors.PrimaryColor),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
                label: 'Search',
                backgroundColor: MyColors.PrimaryColor),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Center(child: Icon(CupertinoIcons.bag)),
                  cartItems > 0
                      ? Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                margin: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                    color: MyColors.PrimaryColor,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(cartItems.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
              label: 'My Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: 'Wish List',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Account',
            ),
          ],
          onTap: (index) async {
            if (mounted)
              setState(() {
                if (index == 1) fromBtm = true;
                selectedPage = index;
              });
            //fromBtm = false;
            final prefs = await SharedPreferences.getInstance();
            String cart = prefs.getString(PrefConstants.inCart) ?? "";
            print(cart);
            if (cart != "") if (mounted)
              setState(() {
                cartItems = cart.split(',').length;
              });
            else if (mounted)
              setState(() {
                cartItems = 0;
              });
          }),
    );
  }
}
