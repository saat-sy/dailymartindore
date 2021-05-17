import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/address/address_model.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/screens/address/addAddress.dart';
import 'package:frontend/screens/address/updateAddress.dart';
import 'package:frontend/services/address_service.dart';
import 'package:frontend/stylesheet/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {


  AddressService service = AddressService();
  APIResponse<List<AddressModel>> _apiResponse;
  bool isLoading = true;
  String error;
  bool _recordFound = false;

  List<AddressModel> address;

  getAddressList() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponse = await service.getAddressList(id);

    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
        isLoading = false;
      });
    } else {
      address = _apiResponse.data;
      setState(() {
        isLoading = false;
        _recordFound = true;
      });
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

  removeAddress(String itemID) async {
    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getInt(PrefConstants.id).toString();

    _apiResponseRemove = await service.removeAddress(itemID, id);

    if (_apiResponse.error) {
      setState(() {
        error = _apiResponse.errorMessage;
        print(error);
      });
    }
    if(address.length == 0){
      setState(() {
        _recordFound = false;
      });
    }
    Navigator.pop(context);
  }

  @override
  initState() {
    getAddressList();
    super.initState();
  }

  Future<void> refresh() async {
    getAddressList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Address'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            onRefresh: refresh,
            child: isLoading ? Center(child: CircularProgressIndicator()) :
              !_recordFound ? Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/empty_address.png",
                        width: MediaQuery.of(context).size.width * 0.5, 
                      ),
                      Text('You have no addresses yet', style: TextStyle(fontSize: 23))
                    ]
                  ),
                ),
              ) :
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: address.length,
                itemBuilder: (context, index) {
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
                                "Are you sure you wish to delete this address?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("DELETE")),
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
                        removeAddress(address[index].id);
                        if(address.length == 1){
                          _recordFound = false;
                        }
                        address.removeAt(index);
                      });
                    },
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => UpdateAddress(
                            addressModel: address[index],
                          )));
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: Offset(0.0, 1.0),
                              blurRadius: 4.0,
                            ),
                          ], 
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              address[index].username,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              address[index].address,
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: SubmitButton(
                text: 'Add Address',
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddAddress()));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
