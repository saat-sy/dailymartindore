import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/products/shopping_cart_model.dart';
import 'package:frontend/screens/order/placeOrder.dart';
import 'package:frontend/stylesheet/styles.dart';



class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  
  List<ShoppingCartModel> items = [
    ShoppingCartModel(
      imagePath: 'assets/images/veg1.png',
      name: 'Organic Lemons',
      price:'\$1.22 x 5',
      bottomText: '1.50 lbs',
    ),
    ShoppingCartModel(
      imagePath: 'assets/images/veg2.png',
      name: 'Fresh Apricots',
      price:'\$1.22 x 5',
      bottomText: 'dozen',
    ),
    ShoppingCartModel(
      imagePath: 'assets/images/veg3.png',
      name: 'Pomogrenate',
      price:'\$1.22 x 5',
      bottomText: 'each',
    ),
    ShoppingCartModel(
      imagePath: 'assets/images/veg1.png',
      name: 'Organic Lemons',
      price:'\$1.22 x 5',
      bottomText: '1.50 lbs',
    ),
    ShoppingCartModel(
      imagePath: 'assets/images/veg2.png',
      name: 'dozen',
      price:'\$1.22 x 5',
      bottomText: 'dozen',
    ),
    ShoppingCartModel(
      imagePath: 'assets/images/veg3.png',
      name: 'Pomogrenate',
      price:'\$1.22 x 5',
      bottomText: 'each',
    ),
  ];

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
      body: Container(
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
                            content: const Text("Are you sure you wish to delete this product from your cart?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("DELETE")
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },

                    onDismissed: (_) {
                      setState(() {
                        items.removeAt(index);
                      });                 
                    },

                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(width: 15,),
                              ClipOval(
                                child: Image(
                                  image: AssetImage(items[index].imagePath),
                                  width: MediaQuery.of(context).size.width * 0.15,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(items[index].price,
                                      style: TextStyle(
                                          color: MyColors.PrimaryColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    items[index].name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    items[index].bottomText,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 30,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(color: Colors.grey.shade200, width: 1),
                                        bottom: BorderSide(color: Colors.grey.shade200, width: 1)
                                      )  
                                    ),
                                    child: Center(child: Text(
                                      '+',
                                      style: TextStyle(
                                        color: MyColors.PrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700
                                      ),
                                    ),),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: Colors.grey.shade200, width: 1),
                                      bottom: BorderSide(color: Colors.grey.shade200, width: 1)
                                    )  
                                  ),
                                  child: Center(child: Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700
                                    ),
                                  ),),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 30,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(color: Colors.grey.shade200, width: 1),
                                      )  
                                    ),
                                    child: Center(child: Text(
                                      '–',
                                      style: TextStyle(
                                        color: MyColors.PrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700
                                      ),
                                    ),),
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
                        '\$16.99',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
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
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '\$0',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Container(child: Divider(height: 1, color: Colors.grey,)),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        '\$16.99',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                        ),
                      ),

                    ],
                  ),

                  SizedBox(height: 10,),

                  SubmitButton(
                    text: 'Checkout',
                    onPress: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PlaceOrder()));
                    },
                  ),

                  SizedBox(height: 20,)


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
