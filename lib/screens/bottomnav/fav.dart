import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/products/favorites_model.dart';

class Favorite extends StatefulWidget {

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  List<FavoritesModel> favorites = [
    FavoritesModel(
      imagePath: 'assets/images/veg1.png',
      name: 'Organic Lemons',
      price:'\$1.22 x 5',
      bottomText: '1.50 lbs',
    ),
    FavoritesModel(
      imagePath: 'assets/images/veg2.png',
      name: 'Fresh Apricots',
      price:'\$1.22 x 5',
      bottomText: 'dozen',
    ),
    FavoritesModel(
      imagePath: 'assets/images/veg3.png',
      name: 'Pomogrenate',
      price:'\$1.22 x 5',
      bottomText: 'each',
    ),
    FavoritesModel(
      imagePath: 'assets/images/veg1.png',
      name: 'Organic Lemons',
      price:'\$1.22 x 5',
      bottomText: '1.50 lbs',
    ),
    FavoritesModel(
      imagePath: 'assets/images/veg2.png',
      name: 'dozen',
      price:'\$1.22 x 5',
      bottomText: 'dozen',
    ),
    FavoritesModel(
      imagePath: 'assets/images/veg3.png',
      name: 'Pomogrenate',
      price:'\$1.22 x 5',
      bottomText: 'each',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Favorites',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: favorites.length,
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
                      content: const Text("Are you sure you wish to delete this product from your favorites?"),
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
                  favorites.removeAt(index);
                });                 
              },

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5) 
                ),
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    
                    Row(
                      children: <Widget>[

                        ClipOval(
                          child: Image(
                            image: AssetImage(favorites[index].imagePath),
                            width: MediaQuery.of(context).size.width * 0.15,
                          ),
                        ),

                        SizedBox(width: 20,),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text(
                              favorites[index].price,
                              style: TextStyle(color: MyColors.PrimaryColor, fontSize: 13, fontWeight: FontWeight.w500)
                            ),

                            SizedBox(height: 4,),

                            Text(
                              favorites[index].name,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                            ),

                            SizedBox(height: 4,),

                            Text(
                              favorites[index].bottomText,
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),

                          ],
                        )

                      ],
                    ),

                    Container(
                      decoration: BoxDecoration(color: Colors.lightGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shopping_bag_outlined, color: MyColors.PrimaryColor, size: 22,),
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
    );
  }
}
