import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reservations/model/restaurant.dart';
import 'package:flutter_reservations/util/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteRestaurantsPage extends StatelessWidget {
  User? user;
  var favoriteRestaurants = <Restaurant>[];

  FavoriteRestaurantsPage(
      {required this.user, required this.favoriteRestaurants});

  Widget buildRow(BuildContext context, Restaurant restaurant) {
    return Card(
        child: new Column(
      children: <Widget>[
        Utils.restaurantImage(context, restaurant, user!, favoriteRestaurants),
        Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: <Widget>[
                Text(
                  restaurant.name,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 26.0,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
              ],
            )),
        Container(
            margin: EdgeInsets.all(10),
            child: Utils.getAddress(context, restaurant))
      ],
    ));
  }

  Widget buildList(BuildContext context, List<Restaurant> restaurants) {
    return ListView.separated(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return buildRow(context, restaurants[index]);
        },
        separatorBuilder: (context, index) {
          return Divider();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.orange,
      ),
      body: buildList(context, this.favoriteRestaurants),
    );
  }
}
