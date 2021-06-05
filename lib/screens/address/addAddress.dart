import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/address/address_model.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/screens/address/address.dart';
import 'package:frontend/services/address_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  AddressService service = AddressService();

  APIResponse<bool> _apiResponse;

  bool isLoading = true;

  String error;

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 55, width: 55, child: CircularProgressIndicator()),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  addAddress() async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    final addressModel = AddressModel(
        username: name,
        address: address,
        state: state,
        pincode: pincode,
        city: city);

    _apiResponse = await service.addAddress(addressModel, id);

    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          Navigator.pop(context);
          error = _apiResponse.errorMessage;
        });
    } else {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Address()));
    }
  }

  bool _makedefault = true;

  String name;
  String address;
  String city;
  String state;
  String pincode;

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
              onChanged: (value) {
                if (mounted)
                  setState(() {
                    name = value;
                  });
              },
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
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (value) {
                if (mounted)
                  setState(() {
                    address = value;
                  });
              },
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
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (value) {
                if (mounted)
                  setState(() {
                    city = value;
                  });
              },
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
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (value) {
                if (mounted)
                  setState(() {
                    state = value;
                  });
              },
              cursorColor: MyColors.PrimaryColor,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  hintText: 'State',
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
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (value) {
                if (mounted)
                  setState(() {
                    pincode = value;
                  });
              },
              cursorColor: MyColors.PrimaryColor,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  hintText: 'Pin Code',
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Transform.scale(
                  scale: 0.6,
                  child: CupertinoSwitch(
                    value: _makedefault,
                    onChanged: (value) {
                      if (mounted)
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
              onPress: () {
                addAddress();
              },
            )
          ],
        ),
      ),
    );
  }
}
