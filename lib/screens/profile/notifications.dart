import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/profile/notification_settings.dart';
import 'package:frontend/strings.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationsModel> notifs = [
    NotificationsModel(
      title: 'Special Offer for Grapes',
      description: 'Today 12:00 PM',
    ),
    NotificationsModel(
      title: 'Special Offer for Musk Melon',
      description: 'Today 12:00 PM',
    ),
    NotificationsModel(
      title: 'Special Offer for Apples',
      description: 'Today 12:00 PM',
    ),
    NotificationsModel(
      title: 'Special Offer for Pomogranate',
      description: 'Today 12:00 PM',
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
        title: Text(Strings.NOTIFICATIONS_APPBAR),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotifSettings()));
            },
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: notifs.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                if (mounted)
                  setState(() {
                    notifs.removeAt(index);
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
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
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
                child: Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: MyColors.PrimaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notifs[index].title,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              notifs[index].description,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationsModel {
  String title;
  String description;

  NotificationsModel({this.title, this.description});
}
