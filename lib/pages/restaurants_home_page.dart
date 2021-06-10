import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_reservations/database_helper.dart';
import 'package:flutter_reservations/model/reservation.dart';
import 'package:flutter_reservations/model/restaurant.dart';
import 'package:flutter_reservations/pages/drawer-menu.dart';
import 'package:flutter_reservations/pages/restaurant_detail_page.dart';
import 'package:flutter_reservations/util/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class RestaurantsList extends StatefulWidget {
  final User? user;

  const RestaurantsList({Key? key, this.user}) : super(key: key);
  @override
  RestaurantsListState createState() => RestaurantsListState(user: user);
}

class RestaurantsListState extends State<RestaurantsList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var restaurantsList = <Restaurant>[];
  var count;
  var favoriteRestaurants = <Restaurant>[];

  final User? user;

  final String applicationName = 'FoodZzz';

  RestaurantsListState({this.user});

  Widget iconsRow(bool favorite, Restaurant restaurant) {
    return Wrap(
      spacing: 12,
      children: <Widget>[
        GestureDetector(
          child: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: favorite ? Colors.red.shade900 : null,
            size: 26,
          ),
          onTap: () {
            setState(() {
              if (favorite) {
                favoriteRestaurants.remove(restaurant);
              } else {
                favoriteRestaurants.add(restaurant);
              }
            });
          },
        ),
        Utils.goToIcon(context, restaurant, user!, favoriteRestaurants),
      ],
    );
  }

  Widget buildRow(
      BuildContext context, Restaurant restaurant, bool alreadyFavorite) {
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
                iconsRow(alreadyFavorite, restaurant)
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
          final alreadyFavorite =
              favoriteRestaurants.contains(restaurants[index]);
          return buildRow(context, restaurants[index], alreadyFavorite);
        },
        separatorBuilder: (context, index) {
          return Divider();
        });
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Restaurant>> restaurantsFuture =
          databaseHelper.getRestaurants();
      restaurantsFuture.then((restaurants) {
        setState(() {
          this.restaurantsList = restaurants;
          this.count = restaurants.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (restaurantsList.isEmpty) {
      restaurantsList = [];
      updateListView();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            applicationName,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Utils.darkRedColor,
        ),
        body: buildList(context, this.restaurantsList),
        drawer:
            DrawerMenu(user: user, favoriteRestaurants: favoriteRestaurants));
  }
}
