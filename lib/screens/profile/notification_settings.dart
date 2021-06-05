import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/strings.dart';

class NotifSettings extends StatefulWidget {
  @override
  _NotifSettingsState createState() => _NotifSettingsState();
}

class _NotifSettingsState extends State<NotifSettings> {
  List<NotifSettingsModel> notifs = [
    NotifSettingsModel(
      title: 'Allow Notifications',
      description: 'Get notifications about what is coming in the cart',
      accepted: false,
    ),
    NotifSettingsModel(
      title: 'Email Notifications',
      description: 'Get notifications about what is coming in the cart',
      accepted: false,
    ),
    NotifSettingsModel(
      title: 'Order Notifications',
      description: 'Get notifications about what is coming in the cart',
      accepted: false,
    ),
    NotifSettingsModel(
      title: 'General Notifications',
      description: 'Get notifications about what is coming in the cart',
      accepted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text(Strings.NOTIFICATIONS_SETTINGS_APPBAR),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            child: ListView.builder(
              itemCount: notifs.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 45,
                        child: CheckboxListTile(
                          title: Text(
                            notifs[index].title,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          value: notifs[index].accepted,
                          activeColor: MyColors.SecondaryColor,
                          onChanged: (newValue) {
                            if (mounted)
                              setState(() {
                                notifs[index].accepted = newValue;
                              });
                          },
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(notifs[index].description),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 45,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: MyColors.SecondaryColor),
              child: Center(
                child: Text(
                  Strings.NOTIFICATIONS_SETTINGS_SUBMIT,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NotifSettingsModel {
  String title;
  String description;
  bool accepted;

  NotifSettingsModel({this.title, this.description, this.accepted});
}
