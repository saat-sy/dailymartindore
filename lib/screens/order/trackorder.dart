import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class TrackOrder extends StatefulWidget {
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Track Order',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                children: <Widget>[

                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.lightGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
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
              )
            ),

            SizedBox(height: 10,),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                children: <Widget>[

                  Row(
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.lightGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(CupertinoIcons.cube_box, color: MyColors.PrimaryColor, size: 22,),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            'Order Placed',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),

                          SizedBox(height: 4,),

                          Text(
                            'December 20, 2020',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),            

                        ],
                      )

                    ],
                  ),

                  Row(
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.lightGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.check_box_outlined, color: MyColors.PrimaryColor, size: 22,),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            'Order Confirmed',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),

                          SizedBox(height: 4,),

                          Text(
                            'December 20, 2020',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),         

                        ],
                      )

                    ],
                  ), 

                  Row(
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.lightGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(CupertinoIcons.map, color: MyColors.PrimaryColor, size: 22,),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            'Order Shipped',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),

                          SizedBox(height: 4,),

                          Text(
                            'December 20, 2020',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),            

                        ],
                      )

                    ],
                  ),
                  
                  Row(
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.delivery_dining, color: Colors.grey, size: 22,),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            'Out for Delivery',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),

                          SizedBox(height: 4,),

                          Text(
                            'Pending',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),            

                        ],
                      )

                    ],
                  ),

                  Row(
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.shopping_bag, color: Colors.grey, size: 22,),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            'Order Delivered',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),

                          SizedBox(height: 4,),

                          Text(
                            'Pending',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),            

                        ],
                      )

                    ],
                  )

                ],
              ),
            )

          ],
        ),
      ),

    );
  }
}