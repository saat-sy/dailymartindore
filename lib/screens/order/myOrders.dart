import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/order/trackorder.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  bool active = false;
  bool active2 = false;
  bool active3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('My Orders'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) { 
                  if(panelIndex == 0)
                    setState(() {
                      active = !active;  
                    });
                  else if(panelIndex == 1)
                    setState(() {
                      active2 = !active2;  
                    });
                  else if(panelIndex == 2)
                    setState(() {
                      active3 = !active3;  
                    });    
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isOpen) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrackOrder()));
                        },
                        child: Row(
                          children: <Widget>[

                            Container(
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(color: MyColors.PrimaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(CupertinoIcons.cube_box_fill, color: MyColors.PrimaryColor, size: 22,),
                              ),
                            ),

                            

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text(
                                  'Order #44658',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),

                                SizedBox(height: 4,),

                                Text(
                                  'Placed on December 20, 2020',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),

                                SizedBox(height: 4,),

                                Row(
                                  children: [
                                    Text(
                                      'Total: \$',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '16.99',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            )

                          ],
                        ),
                      );
                    },
                    body: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: MyColors.PrimaryColor,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Order Placed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)
                                ],
                              ),
                              Text('Dec 10, 2020')
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: MyColors.PrimaryColor,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Order Placed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)
                                ],
                              ),
                              Text('Dec 10, 2020')
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: MyColors.PrimaryColor,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Order Confirmed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)
                                ],
                              ),
                              Text('Dec 10, 2020')
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Out for Delivery')
                                ],
                              ),
                              Text('Pending')
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Order Delivered')
                                ],
                              ),
                              Text('Pending')
                            ],
                          )
                        ],
                      ),
                    ),
                    isExpanded: active,
                  ),

                  ExpansionPanel(
                    headerBuilder: (context, isOpen) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrackOrder()));
                        },
                        child: Row(
                          children: <Widget>[

                            Container(
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(color: MyColors.PrimaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(CupertinoIcons.cube_box_fill, color: MyColors.PrimaryColor, size: 22,),
                              ),
                            ),

                            

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text(
                                  'Order #44658',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),

                                SizedBox(height: 4,),

                                Text(
                                  'Placed on December 20, 2020',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),

                                SizedBox(height: 4,),

                                Row(
                                  children: [
                                    Text(
                                      'Total: \$',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '16.99',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            )

                          ],
                        ),
                      );
                    },
                    body: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: MyColors.PrimaryColor,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Order Placed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)
                                ],
                              ),
                              Text('Dec 10, 2020')
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: MyColors.PrimaryColor,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Order Placed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)
                                ],
                              ),
                              Text('Dec 10, 2020')
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: MyColors.PrimaryColor,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Order Confirmed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)
                                ],
                              ),
                              Text('Dec 10, 2020')
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Out for Delivery')
                                ],
                              ),
                              Text('Pending')
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Order Delivered')
                                ],
                              ),
                              Text('Pending')
                            ],
                          )
                        ],
                      ),
                    ),
                    isExpanded: active2,
                  ),

                  ExpansionPanel(
                    headerBuilder: (context, isOpen) {
                      return Row(
                        children: <Widget>[

                          Container(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(CupertinoIcons.cube_box_fill, color: Colors.grey, size: 22,),
                            ),
                          ),

                          

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Text(
                                'Order #44658',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              SizedBox(height: 4,),

                              Text(
                                'Placed on December 20, 2020',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),

                              SizedBox(height: 4,),

                              Row(
                                children: [
                                  Text(
                                    'Total: \$',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '16.99',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          )

                        ],
                      );
                    },
                    body: Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(50)
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text('Order Delivered')
                            ],
                          ),
                          Text('Dec 10, 2020')
                        ],
                      ),
                    ),
                    isExpanded: active3,
                  ),

                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}