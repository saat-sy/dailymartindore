import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/order/order_details_model.dart';
import 'package:frontend/screens/order/trackorder.dart';
import 'package:frontend/services/order_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackOrderList extends StatefulWidget {
  @override
  _TrackOrderListState createState() => _TrackOrderListState();
}

class _TrackOrderListState extends State<TrackOrderList> {
  OrderService service = OrderService();
  APIResponse<List<OrderDetails>> _apiResponse;
  bool isLoading = true;
  String error = '';

  List<OrderDetails> orders = [];

  getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();
    print(id);

    _apiResponse = await service.getMyOrders(id);
    if (_apiResponse.error) {
      if (mounted)
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
          title: Text('Track Order'),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : orders.length == 0
                ? Center(child: Text('No orders found'))
                : Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                offset: Offset(0.0, 1.0),
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TrackOrder(
                                            orderID: orders[index].orderID,
                                            total: orders[index].total,
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
                                      'Order #${orders[index].orderID}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
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
                                          '₹${orders[index].total}',
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
                          ),
                        );
                      },
                    ),
                  ));
  }
}
