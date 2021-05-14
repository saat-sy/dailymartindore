import 'package:flutter/material.dart';
import 'package:frontend/screens/address/addAddress.dart';
import 'package:frontend/stylesheet/styles.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  List<String> names = ['Name 1', 'Name 2', 'Name 3', 'Name 4'];
  List<String> addresses = ['Address 1', 'Address 2', 'Address 3', 'Address 4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Address'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5) 
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        names[index],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        addresses[index],
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: SubmitButton(
                text: 'Add Address',
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddAddress()));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
