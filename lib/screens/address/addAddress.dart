import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/stylesheet/styles.dart';

import '../../constants.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {

  bool _makedefault = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Add Address',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            TextFormField(
              maxLines: null,
              cursorColor: MyColors.PrimaryColor,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  hintText: 'Name',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Visibility(
                      visible: true,
                      child: Icon(
                        Icons.person_outline_outlined,
                        color: Colors.grey,
                        size: 17,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0))),
            ),

            SizedBox(height: 10,),

            TextFormField(
              maxLines: null,
              cursorColor: MyColors.PrimaryColor,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  hintText: 'Email address',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Visibility(
                      visible: true,
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                        size: 17,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0))),
            ),
            SizedBox(height: 10,),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              maxLines: null,
              cursorColor: MyColors.PrimaryColor,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  hintText: 'Phone',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Visibility(
                      visible: true,
                      child: Icon(
                        Icons.phone_outlined,
                        color: Colors.grey,
                        size: 17,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0))),
            ),
            SizedBox(height: 10,),
            TextFormField(
              maxLines: null,
              cursorColor: MyColors.PrimaryColor,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  hintText: 'Address',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Visibility(
                      visible: true,
                      child: Icon(
                        Icons.pin_drop_outlined,
                        color: Colors.grey,
                        size: 17,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0))),
            ),
            SizedBox(height: 10,),
            TextFormField(
              maxLines: null,
              cursorColor: MyColors.PrimaryColor,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  hintText: 'Zip Code',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Visibility(
                      visible: true,
                      child: Icon(
                        Icons.maps_ugc_outlined,
                        color: Colors.grey,
                        size: 17,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0))),
            ),
            SizedBox(height: 10,),
            TextFormField(
              maxLines: null,
              cursorColor: MyColors.PrimaryColor,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  hintText: 'City',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Visibility(
                      visible: true,
                      child: Icon(
                        Icons.map_outlined,
                        color: Colors.grey,
                        size: 17,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0))),
            ),
            SizedBox(height: 10,),
            TextFormField(
              maxLines: null,
              cursorColor: MyColors.PrimaryColor,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  hintText: 'Country',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Visibility(
                      visible: true,
                      child: Icon(
                        CupertinoIcons.globe,
                        color: Colors.grey,
                        size: 17,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.white, width: 1.0))),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Transform.scale(
                  scale: 0.6,
                  child: CupertinoSwitch(
                    value: _makedefault,
                    onChanged: (value) {
                      setState(() {
                        _makedefault = value;
                      });
                    },
                    activeColor: MyColors.PrimaryColor,
                  ),
                ),
                Text(
                  'Make Default',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                )
              ],
            ),
            SizedBox(height: 30),
            SubmitButton(
              text: 'Save address',
              onPress: () {},
            )
          ],
        ),
      ),
    );
  }
}
