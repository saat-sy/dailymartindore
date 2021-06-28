import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/bottomnav/home.dart';
import 'package:frontend/screens/bottomnav/search.dart';

class BottomNavAnonymous extends StatefulWidget {
  final int index;
  final String brands;
  final String searchTerm;

  BottomNavAnonymous({this.searchTerm ,this.index, this.brands});

  @override
  _BottomNavAnonymousState createState() => _BottomNavAnonymousState();
}

class _BottomNavAnonymousState extends State<BottomNavAnonymous> {
  int selectedPage = 0;
  List _pageOption = [];
  bool indexUsed = false;

  @override
  void initState() {
    _pageOption = [Home(), Search()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!indexUsed) {
      selectedPage = widget.index ?? 0;
      indexUsed = true;
    }

    return Scaffold(
      body: SafeArea(
        child: selectedPage == 1
            ? Search(
                fromBottomNav: widget.searchTerm == null,
                brands: widget.brands,
                searchTerm: widget.searchTerm,
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
          ],
          onTap: (index) async {
            if (mounted)
              setState(() {
                if (widget.searchTerm != null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => BottomNavAnonymous(index: index,),
                    ),
                    (route) => false,
                  );
                }
                else
                  selectedPage = index;
              });
          }),
    );
  }
}
