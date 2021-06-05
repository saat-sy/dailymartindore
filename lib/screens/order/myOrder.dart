import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/order/order_details_model.dart';
import 'package:frontend/screens/order/trackorder.dart';
import 'package:frontend/services/order_service.dart';
import 'package:frontend/strings.dart';
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

  List<OrderDetails> orders = [];

  getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

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
      if (mounted) if (mounted)
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
          title: Text(Strings.MY_ORDER_APPBAR),
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
                        return MyExpansionTile(
                            order: orders[index], context: context);
                      },
                    ),
                  ));
  }
}

class MyExpansionTile extends StatelessWidget {
  final BuildContext context;
  final OrderDetails order;

  MyExpansionTile({this.context, this.order});

  @override
  Widget build(BuildContext context) {
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
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        key: PageStorageKey<OrderDetails>(order),
        title: InkWell(
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
                    'Order #${order.orderID}',
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
        ),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
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
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.productTitle,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
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
        ],
      ),
    );
  }
}
