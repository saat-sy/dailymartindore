import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileService service = ProfileService();
  bool isLoading = false;
  String error = '';

  User user;

  String name;
  String email;
  String phoneNo;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneNoController = TextEditingController();

  String currentName;
  String currentPhone;

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString(PrefConstants.name).toString();
    emailController.text = prefs.getString(PrefConstants.email).toString();
    phoneNoController.text = prefs.getString(PrefConstants.phone).toString();
    currentName = prefs.getString(PrefConstants.name).toString();
    currentPhone = prefs.getString(PrefConstants.phone).toString();
  }

  APIResponse<bool> _apiResponse;

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

  updateProfile() async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponse = await service.updateProfile(phoneNo ?? currentPhone, name ?? currentName, id);

    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
      });
    } else {
      await updateShredPrefs(
        name ?? prefs.getString(PrefConstants.name).toString(),
        phoneNo ?? prefs.getString(PrefConstants.phone).toString(),
      );
    }
    Navigator.pop(context);
  }


  Future<void> updateShredPrefs(String name, String phone) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefConstants.name, name);
    await prefs.setString(PrefConstants.phone, phone);
  }

  @override
  initState() {
    getData();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  bool update = false;

  String verifyPhoneNo(String val) {
    if (val.isEmpty)
      return 'Enter your Phone number';
    else if (val.length != 10)
      return 'Enter a valid Phone number';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('About Me'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Name:',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextFormField(
                            controller: nameController,
                            validator: (val) =>
                                val.isEmpty ? 'Enter your name' : null,
                            onChanged: (value) {
                              setState((){
                                if (value != currentName) {
                                  name = value;
                                  update = true;
                                } else
                                  update = false;
                              });
                            },
                            cursorColor: MyColors.PrimaryColor,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              hintText: 'Name',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Email:',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextFormField(
                            controller: emailController,
                            enableInteractiveSelection: false,
                            focusNode: AlwaysDisabledFocusNode(),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              hintText: 'Email',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Phone:',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextFormField(
                            controller: phoneNoController,
                            validator: (val) => verifyPhoneNo(val),
                            onChanged: (value) {
                              setState(() {
                                if (value != currentPhone) {
                                  phoneNo = value;
                                  update = true;
                                } else
                                  update = false;
                              });
                            },
                            cursorColor: MyColors.PrimaryColor,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              hintText: 'Phone No',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(error, style: TextStyle(color: Colors.red),),
                    SizedBox(
                      height: 10,
                    ),
                    update
                        ? SubmitButton(
                            text: 'Update Profile',
                            onPress: () {
                              updateProfile();
                            })
                        : Container()
                  ],
                ),
              ),
            ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
