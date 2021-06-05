import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/order/track_order_model.dart';
import 'package:frontend/services/order_service.dart';
import 'package:frontend/strings.dart';

import '../../constants.dart';

class TrackOrder extends StatefulWidget {
  final String orderID;
  final String total;
  TrackOrder({this.orderID, this.total});
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  OrderService service = OrderService();
  APIResponse<List<TrackOrderModel>> _apiResponse;
  List<TrackOrderModel> track;

  String error;
  bool isLoading = true;

  bool one = false,
      two = false,
      three = false,
      four = false,
      five = false,
      six = false;

  String oneDate, twoDate, threeDate, fourDate, fiveDate, sixDate;

  var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String convertDateTime(String s) {
    final d = DateTime.parse(s);
    return '${d.day} ${months[d.month - 1]}, ${d.year}  ${d.hour}:${d.minute}';
  }

  trackOrder() async {
    _apiResponse = await service.trackOrder(widget.orderID);
    if (_apiResponse.error) {
      error = _apiResponse.errorMessage;
      print(error);
    } else {
      track = _apiResponse.data;

      for (final t in track) {
        int status = int.parse(t.status);
        print(status);
        switch (status) {
          case 0:
            one = true;
            oneDate = convertDateTime(t.date);
            break;

          case 1:
            two = true;
            twoDate = convertDateTime(t.date);
            break;

          case 4:
            three = true;
            threeDate = convertDateTime(t.date);
            break;

          case 5:
            four = true;
            fourDate = convertDateTime(t.date);
            break;

          case 6:
            five = true;
            fiveDate = convertDateTime(t.date);
            break;

          case 7:
          case 8:
            six = true;
            sixDate = convertDateTime(t.date);
            break;
        }
      }

      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }

  @override
  void initState() {
    trackOrder();
    super.initState();
  }

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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: MyColors.PrimaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.cube_box_fill,
                                color: MyColors.PrimaryColor,
                                size: 22,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Order #${widget.orderID}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Placed on $oneDate',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Total: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '₹${widget.total}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: one
                                      ? MyColors.PrimaryColor.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.note_add_outlined,
                                  color:
                                      one ? MyColors.PrimaryColor : Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Strings.TRACK_ORDER_ORDER_PLACED,
                                  style: TextStyle(
                                      color: one ? Colors.black : Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  one ? oneDate : Strings.TRACK_ORDER_PENDING,
                                  style: TextStyle(
                                    color: one ? Colors.black : Colors.grey,
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
                              decoration: BoxDecoration(
                                  color: two
                                      ? MyColors.PrimaryColor.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.check_box_outlined,
                                  color:
                                      two ? MyColors.PrimaryColor : Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Strings.TRACK_ORDER_ORDER_CONFIRMED,
                                  style: TextStyle(
                                      color: two ? Colors.black : Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  two ? twoDate : Strings.TRACK_ORDER_PENDING,
                                  style: TextStyle(
                                    color: two ? Colors.black : Colors.grey,
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
                              decoration: BoxDecoration(
                                  color: three
                                      ? MyColors.PrimaryColor.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  CupertinoIcons.cube_box,
                                  color: three
                                      ? MyColors.PrimaryColor
                                      : Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Strings.TRACK_ORDER_ORDER_PACKED,
                                  style: TextStyle(
                                      color: three ? Colors.black : Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  three
                                      ? threeDate
                                      : Strings.TRACK_ORDER_PENDING,
                                  style: TextStyle(
                                    color: three ? Colors.black : Colors.grey,
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
                              decoration: BoxDecoration(
                                  color: four
                                      ? MyColors.PrimaryColor.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  CupertinoIcons.map,
                                  color: four
                                      ? MyColors.PrimaryColor
                                      : Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Strings.TRACK_ORDER_ORDER_SHIPPED,
                                  style: TextStyle(
                                      color: four ? Colors.black : Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  four ? fourDate : Strings.TRACK_ORDER_PENDING,
                                  style: TextStyle(
                                    color: four ? Colors.black : Colors.grey,
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
                              decoration: BoxDecoration(
                                  color: five
                                      ? MyColors.PrimaryColor.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.delivery_dining,
                                  color: five
                                      ? MyColors.PrimaryColor
                                      : Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Strings.TRACK_ORDER_OUT_FOR_DELIVERY,
                                  style: TextStyle(
                                      color: five ? Colors.black : Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  five ? fiveDate : Strings.TRACK_ORDER_PENDING,
                                  style: TextStyle(
                                    color: five ? Colors.black : Colors.grey,
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
                              decoration: BoxDecoration(
                                  color: six
                                      ? MyColors.PrimaryColor.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.shopping_bag,
                                  color:
                                      six ? MyColors.PrimaryColor : Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Strings.TRACK_ORDER_ORDER_DELIVERED,
                                  style: TextStyle(
                                      color: six ? Colors.black : Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  six ? sixDate : Strings.TRACK_ORDER_PENDING,
                                  style: TextStyle(
                                    color: six ? Colors.black : Colors.grey,
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
