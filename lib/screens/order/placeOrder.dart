import 'package:flutter/material.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/stylesheet/styles.dart';

import '../../constants.dart';

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  int currentIndex = -1;
  int pageIndex = 0;

  List<String> names = ['Name 1', 'Name 2', 'Name 3', 'Name 4'];
  List<String> addresses = ['Address 1', 'Address 2', 'Address 3', 'Address 4'];

  PageController pageController = PageController();

  void animateToNextPage(int index) {
    currentIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  String _selectedMethod = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: PageView(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          //ADDRESS
          Container(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Select your Address',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                          itemCount: names.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                    index == currentIndex
                                        ? Icon(
                                            Icons.check,
                                            color: MyColors.PrimaryColor,
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNav()));
                          },
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: MyColors.PrimaryColor),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: MyColors.PrimaryColor),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (currentIndex != -1) {
                              animateToNextPage(pageIndex + 1);
                            }
                          },
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: MyColors.PrimaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                              ),
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

          //PAYMENT
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    height: MediaQuery.of(context).size.height,
                    child: Column(children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'More features will be added to this when implementing the API',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Select your Payment Method',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        leading: Radio(
                          value: 'Credit Card',
                          groupValue: _selectedMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedMethod = value;
                            });
                          },
                        ),
                        title: Text('Credit/Debit Card'),
                      ),
                      ListTile(
                        leading: Radio(
                          value: 'Cash on Delivery',
                          groupValue: _selectedMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedMethod = value;
                            });
                          },
                        ),
                        title: Text('Cash on Delivery'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add a coupon',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  height: 40,
                                  child: TextFormField(
                                    cursorColor: MyColors.PrimaryColor,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                      hintText: 'Enter code',
                                      fillColor: Colors.white,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(color: MyColors.PrimaryColor, width: 1.0)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(color: Colors.red, width: 1.0)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(color: Colors.red, width: 1.0)),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 5),

                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey.shade200, width: 1.0)
                                    ),
                                    child: Center(child: Text('Apply'))
                                  ),
                                )

                              ]
                            ),
                          ],
                        ),
                      )
                    ])),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNav()));
                          },
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: MyColors.PrimaryColor),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: MyColors.PrimaryColor),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (currentIndex > 0) {
                              animateToNextPage(currentIndex + 1);
                            }
                          },
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: MyColors.PrimaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                'Continue',
                                style: TextStyle(color: Colors.white),
                              ),
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

          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                SubmitButton(
                  text: 'Place your order'
                ),
                SizedBox(height: 20),
                Text('Order Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1)  
                  ),
                  child: Column(
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                Text(
                                  '\$16.99',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Shipping',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                Text(
                                  '\$0',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(child: Divider(height: 2, color: Colors.grey.shade500,)),


                      Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Total',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            Text(
                              '\$16.99',
                              style: TextStyle(
                                color: MyColors.PrimaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700
                              ),
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ]
            )
          )
        ],
      ),
    );
  }
}
