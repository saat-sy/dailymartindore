import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/order/order_details_model.dart';
import 'package:frontend/screens/order/trackorder.dart';
import 'package:frontend/services/order_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  OrderService service = OrderService();
  APIResponse<List<OrderDetails>> _apiResponse;
  bool isLoading = true;
  String error = '';

  List<OrderDetails> orders;

  getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponse = await service.getMyOrders(id);
    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
        isLoading = false;
        print(error);
      });
    } else {
      orders = _apiResponse.data;
      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }

  @override
  initState() {
    getOrders();
    super.initState();
  }

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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          orders[index].isExpanded = !orders[index].isExpanded;
                        });
                      },
                      children: orders.map((OrderDetails order) {
                        return ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TrackOrder(
                                          orderID: order.orderID,
                                          total: order.total,
                                        )));
                              },
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: MyColors.PrimaryColor.withOpacity(
                                            0.2),
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
                                        'Order #${order.orderID}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                                            '₹${order.total}',
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
                              ),
                            );
                          },
                          isExpanded: order.isExpanded,
                          body: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.network(
                                      order.image,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(width: 15,),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.productTitle,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Price: ${order.price}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Text(
                                          'Quantity: ${order.quantity}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Text(
                                  'Status: ${order.type}',
                                  style: TextStyle(
                                    color: MyColors.PrimaryColor,
                                  ),
                                )
                              ],
                            ),
                          ), 
                        );
                      }
                    ).toList(),
                ),
                  ),
              ],
            )
          );
  }
}
