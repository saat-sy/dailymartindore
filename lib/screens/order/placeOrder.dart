import 'package:flutter/material.dart';
import 'package:frontend/models/address/address_model.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/order/order_model.dart';
import 'package:frontend/models/order/payment_models.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/screens/order/myOrder.dart';
import 'package:frontend/services/address_service.dart';
import 'package:frontend/services/cart_service.dart';
import 'package:frontend/services/order_service.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class PlaceOrder extends StatefulWidget {
  String productID;
  String quantity;
  String amount;

  PlaceOrder({this.productID, this.quantity, this.amount});

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  OrderService service = OrderService();
  Text errorcoupon;
  bool isAddressLoading = true;

  APIResponse<bool> _apiResponseOrder;
  APIResponse<bool> _apiResponseCoupon;
  APIResponse<List<PaymentMethods>> _apiResponsePayment;

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

  showOrderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        backgroundColor: Colors.white,
        content: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Order Success',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Your order is being processed by the system, you can see the progress at',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyOrder()));
                },
                child: Text(
                  'My Order',
                  style: TextStyle(
                    color: MyColors.SecondaryColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Image.asset(
                'assets/images/order_confirmed.png',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BottomNav()));
                },
                child: Container(
                  color: MyColors.SecondaryColor,
                  padding: EdgeInsets.all(5),
                  child: Text('Go back', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ));
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  CartService servicecart = CartService();
  APIResponse<bool> _apiResponseRemove;

  deleteFromCart() async {

    final products = widget.productID.split(',');

    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getInt(PrefConstants.id).toString();

    for (var product in products) {
      _apiResponseRemove =
          await servicecart.deleteFromCart(userId: userId, productId: product);
    }
  }

  placeOrder() async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();
    String email = prefs.getString(PrefConstants.email);
    String phone = prefs.getString(PrefConstants.phone);

    print(currentIndexAddress);
    print(address[currentIndexAddress].address);

    OrderModel o = OrderModel(
        firstName: address[currentIndexAddress].username ?? 'User',
        lastName: address[currentIndexAddress].username ?? 'User',
        email: email,
        phone: phone,
        city: address[currentIndexAddress].city,
        postCode: address[currentIndexAddress].pincode,
        address: address[currentIndexAddress].address,
        paymentType: _selectedMethod,
        id: widget.productID,
        quantity: widget.quantity,
        totalAmount: widget.amount,
        userID: id);

    _apiResponseOrder = await service.placeOrder(o);

    if (_apiResponseOrder.error) {
      setState(() {
        error = _apiResponseOrder.errorMessage;
      });
      print(error);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      showOrderDialog(context);

      deleteFromCart();
    }
  }

  bool isPaymentLoading = true;
  String errorPayment = '';

  List<PaymentMethods> payment;

  getPaymentMethods() async {
    _apiResponsePayment = await service.getPaymentList();
    if (_apiResponsePayment.error) {
      setState(() {
        errorPayment = _apiResponsePayment.errorMessage;
      });
    } else {
      payment = _apiResponsePayment.data;
      setState(() {
        isPaymentLoading = false;
      });
    }
  }

  //APPLY COUPONS
  applyCoupon() async {
    showLoaderDialog(context);

    _apiResponseCoupon = await service.applyCoupon(coupon);

    if (_apiResponseCoupon.error) {
      setState(() {
        errorcoupon = Text(
          _apiResponseCoupon.errorMessage,
          style: TextStyle(color: Colors.red),
        );
      });
    } else {
      setState(() {
        errorcoupon = Text(
          'Coupon applied successfully',
          style: TextStyle(color: Colors.green),
        );
      });
    }
    Navigator.pop(context);
  }

  //GET ADDRESSES
  AddressService addressService = AddressService();
  APIResponse<List<AddressModel>> _apiResponse;
  String error;
  bool _recordFound = false;

  List<AddressModel> address;

  getAddressList() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponse = await addressService.getAddressList(id);

    if (_apiResponse.error) {
      setState(() {
        print(error);
        error = _apiResponse.errorMessage;
        isAddressLoading = false;
      });
    } else {
      address = _apiResponse.data;
      print('true');
      setState(() {
        isAddressLoading = false;
        _recordFound = true;
      });
    }
  }

  String coupon;

  int currentIndex = 0;
  int currentIndexAddress = -1;
  int pageIndex = 0;

  PageController pageController = PageController();

  void animateToNextPage(int index) {
    print(index);
    currentIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  String _selectedMethod = "";

  @override
  void initState() {
    errorcoupon = Text('');
    getAddressList();
    getPaymentMethods();
    super.initState();
  }

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
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) => pageIndex = index,
        children: <Widget>[
          //ADDRESS
          Container(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  height: MediaQuery.of(context).size.height,
                  child: isAddressLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                itemCount: address.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentIndexAddress = index;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
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
                                                address[index].username,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                address[index].address,
                                                style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          index == currentIndexAddress
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
                            if (currentIndexAddress != -1) {
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
                      Text(
                        'Select your Payment Method',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        errorPayment,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      isPaymentLoading
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                              child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: payment.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Radio(
                                    value: payment[index].name,
                                    groupValue: _selectedMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedMethod = value;
                                      });
                                    },
                                  ),
                                  title: Text(payment[index].value),
                                );
                              },
                            )),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add a coupon',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: 40,
                                    child: TextFormField(
                                      onChanged: (val) => coupon = val,
                                      cursorColor: MyColors.PrimaryColor,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 10.0),
                                        hintText: 'Enter code',
                                        fillColor: Colors.white,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200,
                                                width: 1.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                color: MyColors.PrimaryColor,
                                                width: 1.0)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 1.0)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 1.0)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  InkWell(
                                    onTap: () {
                                      applyCoupon();
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: Colors.grey.shade200,
                                                width: 1.0)),
                                        child: Center(child: Text('Apply'))),
                                  )
                                ]),
                            SizedBox(
                              height: 10,
                            ),
                            errorcoupon,
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
                            if (currentIndex > 0) {
                              animateToNextPage(currentIndex - 1);
                            }
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
                                'Back',
                                style: TextStyle(color: MyColors.PrimaryColor),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (currentIndex > 0 && _selectedMethod != "") {
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
                      text: 'Place your order',
                      onPress: () {
                        placeOrder();
                      },
                    ),
                    SizedBox(height: 25),
                    Text('Order Summary',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Subtotal',
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '₹' + widget.amount,
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Shipping',
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '₹0',
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              child: Divider(
                            height: 2,
                            color: Colors.grey.shade500,
                          )),
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
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '₹' + widget.amount,
                                  style: TextStyle(
                                      color: MyColors.PrimaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (currentIndex > 0)
                              animateToNextPage(currentIndex - 1);
                          },
                          child: Text(
                            'Go Back',
                            style: TextStyle(color: MyColors.PrimaryColor),
                          ),
                        ),
                      ],
                    )
                  ]))
        ],
      ),
    );
  }
}
