import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/authenticate/login.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatelessWidget {
  
  Future<String> _getWidget() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(PrefConstants.name);
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getWidget(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == "" || snapshot.data == null)
            return Login();
          else
            return BottomNav();
        }
        else return CircularProgressIndicator();
      },
    );
  }
}
