import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/screens/bottomnav/bottomnav.dart';
import 'package:frontend/stylesheet/styles.dart';

import '../../constants.dart';

class RateApp extends StatefulWidget {
  @override
  _RateAppState createState() => _RateAppState();
}

class _RateAppState extends State<RateApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Write Review',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              'What do you think?',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ), 

            SizedBox(height: 20,),

            Text(
              'Please give your rating by clicking on the stars below.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),

            SizedBox(height: 20,), 

            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),

            SizedBox(height: 30,),

            TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                cursorColor: MyColors.PrimaryColor,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                    hintText: 'Tell us about your experience',
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Visibility(
                        visible: true,
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.grey,
                          size: 17,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.white, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.white, width: 1.0))),
              ),

              SizedBox(height: 30,),

            SubmitButton(
              text: 'Submit',
              onPress: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomNav()));
              },
            ),  
            
          ],
        ),
      ),
    );
  }
}