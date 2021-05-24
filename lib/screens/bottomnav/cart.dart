import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/product.dart';
import 'package:frontend/models/products/shopping_cart_model.dart';
import 'package:frontend/screens/order/placeOrder.dart';
import 'package:frontend/services/cart_service.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  CartService service = CartService();

  APIResponse<List<ShoppingCartModel>> _apiResponse;

  bool isLoading = true;
  String error = "";
  bool _recordFound = false;

  List<ShoppingCartModel> items2;

  String subtotal;

  Future<void> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponse = await service.getCart(id);
    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
        isLoading = false;
      });
    } else {
      items2 = _apiResponse.data;
      double total = 0.0;
      for(var item in items2){
        total += double.parse(item.sumPrice);
      }
      subtotal = total.toString();
      await getProductDetails();
      setState(() {
        isLoading = false;
        _recordFound = true;
      });
    }
  }

  final items = <ShoppingCartModel>[];

  getProductDetails() async {
    ProductService serviceProduct = ProductService();
    APIResponse<ProductModel> _apiResponseProduct;
    ProductModel p = ProductModel();

    for(var item in items2) {
      _apiResponseProduct = await serviceProduct.getProductByID(item.productID);
      p = _apiResponseProduct.data;
      final i = ShoppingCartModel(
        imagePath: p.image[0],
        title: p.title,
        price: item.price,
        oldPrice: item.oldPrice,
        rating: p.rating,
        discount: p.discount,
        description: p.description,
        numAdded: item.numAdded,
        productID: p.id
      );
      items.add(i);
    }
  }

  APIResponse<bool> _apiResponseRemove;

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

  deleteFromCart(String itemID) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getInt(PrefConstants.id).toString();

    print(itemID);

    _apiResponseRemove = await service.deleteFromCart(userId: userId, productId: itemID);

    if (_apiResponseRemove.error) {
      setState(() {
        error = _apiResponseRemove.errorMessage;
      });
    }
    else print('Success');
    Navigator.pop(context);
  }

  @override
  void initState() {
    getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Container(
              child: Center(
                  child: CircularProgressIndicator()
              )
            )
              : !_recordFound
              ? Center(
                child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/empty_favorites.png",
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    Text('You have no items in your cart',
                        style: TextStyle(fontSize: 23))
                  ]),
            ),
          )
        : Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              height: MediaQuery.of(context).size.height * 0.53,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5)),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you wish to delete this product from your cart?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("DELETE")),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (_) async {
                      await deleteFromCart(items[index].productID);
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              ClipOval(
                                child: Image.network(
                                  items[index].imagePath,
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '₹' + items[index].price,
                                        style: TextStyle(
                                          color: MyColors.PrimaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      items[index].discount != null
                                          ? Container(
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: MyColors.PrimaryColor
                                                      .withOpacity(0.15)),
                                              child: Center(
                                                child: Text(
                                                  items[index].discount +
                                                      '% OFF',
                                                  style: TextStyle(
                                                      color:
                                                          MyColors.PrimaryColor,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                  Text(
                                    items[index].title,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    child: Text(
                                      items[index].description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                  ),
                                  RatingBarIndicator(
                                    rating: items[index].rating != null
                                        ? double.parse(items[index].rating)
                                        : 0,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 13.0,
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      items[index].numAdded = (int.parse(items[index].numAdded) + 1).toString();
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Colors.grey.shade200,
                                                width: 1),
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200,
                                                width: 1))),
                                    child: Center(
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                            color: MyColors.PrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  width: 45,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1),
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1))),
                                  child: Center(
                                    child: Text(
                                      items[index].numAdded,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if(int.parse(items[index].numAdded) > 1)
                                      setState(() {
                                        items[index].numAdded = (int.parse(items[index].numAdded) - 1).toString();
                                      });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        border: Border(
                                      left: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 1),
                                    )),
                                    child: Center(
                                      child: Text(
                                        '–',
                                        style: TextStyle(
                                            color: MyColors.PrimaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    background: Container(
                      color: Colors.red,
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          CupertinoIcons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Subtotal',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '₹' + subtotal,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Shipping',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '₹0',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: Divider(
                    height: 1,
                    color: Colors.grey,
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '₹' + subtotal,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SubmitButton(
                    text: 'Checkout',
                    onPress: () {
                      String productIds = '';
                      String quantities = '';
                      for(final item in items) {
                        if(productIds == '')
                          productIds += item.productID;
                        else
                          productIds += ',${item.productID}';

                        if(quantities == '')
                          quantities += item.numAdded;
                        else
                          quantities += ',${item.numAdded}';
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceOrder(
                            productID: productIds,
                            quantity: quantities,
                            amount: subtotal,
                              )));
                    },
                  ),
                  SizedBox(
                    height: 20,
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
