import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/products/favorites_model.dart';
import 'package:frontend/models/products/product.dart';
import 'package:frontend/models/products/shopping_cart_model.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/authenticate/forgot_password.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/screens/authenticate/signup.dart';
import 'package:frontend/screens/bottomnav/bottomnav_anonymous.dart';
import 'package:frontend/services/authenticate_service.dart';
import 'package:frontend/services/cart_service.dart';
import 'package:frontend/services/favorites_service.dart';
import 'package:frontend/services/products_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthenticateService service = AuthenticateService();
  APIResponse<User> _apiResponse;
  bool isLoading = false;

  getFavs() async {
    FavoriteService service = FavoriteService();
    APIResponse<List<FavoritesModel>> _apiResponse;
    List<FavoritesModel> favorites;

    String favs = "";

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString() ?? "-1";

    _apiResponse = await service.getFavorites(id);

    if (!_apiResponse.error) {
      favorites = _apiResponse.data;
      for (final fav in favorites) {
        if (favs.isNotEmpty) favs += ',';
        favs += fav.id;
      }
    }

    if (favs.length >= 0) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(PrefConstants.inFav, favs);
    }
  }

  getCart() async {
    String cart = "";

    CartService service = CartService();
    APIResponse<List<ShoppingCartModel>> _apiResponse;

    List<ShoppingCartModel> items2;

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString() ?? "-1";

    print(id);

    _apiResponse = await service.getCart(id);
    if (!_apiResponse.error) {
      items2 = _apiResponse.data;

      ProductService serviceProduct = ProductService();
      APIResponse<ProductModel> _apiResponseProduct;
      ProductModel p = ProductModel();

      for (var item in items2) {
        _apiResponseProduct =
            await serviceProduct.getProductByID(item.productID);
        p = _apiResponseProduct.data;
        if (cart.isNotEmpty) cart += ',';
        cart += p.id;
      }
    }
    if (cart.length >= 0) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(PrefConstants.inCart, cart);
    }
  }

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

  login() async {
    showLoaderDialog(context);

    _apiResponse = await service.login(email, password);

    if (_apiResponse.error) {
      if (mounted)
        setState(() {
          error = _apiResponse.errorMessage;
        });
      Navigator.pop(context);
    } else {
      if (_rememberme) {
        User user = _apiResponse.data;

        await updateShredPrefs(
            user.name, user.email, user.phoneNo, user.userID);
      } else {
        await getCart();
        await getFavs();
      }
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => BottomNav(),
        ),
        (route) => false,
      );
    }
  }

  Future<void> updateShredPrefs(
      String name, String email, String phone, int userID) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefConstants.email, email);
    await prefs.setString(PrefConstants.name, name);
    await prefs.setString(PrefConstants.phone, phone);
    await prefs.setInt(PrefConstants.id, userID);
  }

  String error = "";

  bool _obscureText = true;
  bool _rememberme = false;

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  // ignore: missing_return
  String verifyEmail(String val) {
    if (val.isEmpty)
      return 'Enter your Email or Phone number';
    else if (double.tryParse(val) != null) {
      if (val.length != 10) return 'Enter a valid Phone number';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(val))
      return 'Enter a valid Email Address';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNavAnonymous()));
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Skip',
                  style: TextStyle(color: MyColors.PrimaryColor),
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/login_bottom.png',
              width: MediaQuery.of(context).size.width * 0.75,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.075,
                  ),
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Text(
                    'Sign in to your account.',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  TextFormField(
                    validator: (val) => verifyEmail(val),
                    onChanged: (value) {
                      if (mounted)
                        setState(() {
                          email = value;
                        });
                    },
                    cursorColor: MyColors.PrimaryColor,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      hintText: 'Email / Phone Number',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Visibility(
                          visible: true,
                          child: Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                            size: 17,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              BorderSide(color: Colors.red, width: 1.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              BorderSide(color: Colors.red, width: 1.0)),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter a Password' : null,
                    onChanged: (value) {
                      if (mounted)
                        setState(() {
                          password = value;
                        });
                    },
                    cursorColor: MyColors.PrimaryColor,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      hintText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Visibility(
                        visible: true,
                        child: Icon(
                          Icons.lock_outlined,
                          color: Colors.grey,
                          size: 17,
                        ),
                      ),
                      suffixIcon: Visibility(
                        visible: true,
                        child: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 17,
                          ),
                          color: Colors.grey,
                          onPressed: () {
                            if (mounted)
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                          },
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              BorderSide(color: Colors.red, width: 1.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                              BorderSide(color: Colors.red, width: 1.0)),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              value: _rememberme,
                              onChanged: (value) {
                                if (mounted)
                                  setState(() {
                                    _rememberme = value;
                                  });
                              },
                              activeColor: MyColors.SecondaryColor,
                            ),
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12),
                          )
                        ],
                      ),
                      TextButton(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: MyColors.SecondaryColor),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                      )
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  SubmitButton(
                    text: 'Login',
                    onPress: () {
                      if (_formKey.currentState.validate()) login();
                    },
                  ),

                  //SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signup()));
                        },
                        child: Text(
                          'Signup',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
