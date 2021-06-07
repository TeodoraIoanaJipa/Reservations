import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_reservations/database_helper.dart';
import 'package:flutter_reservations/model/reservation.dart';
import 'package:flutter_reservations/model/restaurant.dart';
import 'package:flutter_reservations/pages/drawer-menu.dart';
import 'package:flutter_reservations/pages/restaurant_detail_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class RestaurantsList extends StatefulWidget {
  final User? user;

  const RestaurantsList({Key? key, this.user}) : super(key: key);
  @override
  _RestaurantsListState createState() => _RestaurantsListState(user: user);
}

class _RestaurantsListState extends State<RestaurantsList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var restaurantsList = <Restaurant>[];
  var count;
  var favoriteRestaurants = <Restaurant>[];

  final User? user;

  _RestaurantsListState({this.user});

  

  void _goToRestaurantDetails(Restaurant restaurant) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RestaurantDetailsPage(
                  restaurant: restaurant,
                  user: user,
                  favoriteRestaurants: favoriteRestaurants,
                )));
  }

  Widget _iconsRow(bool favorite, Restaurant restaurant) {
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
        GestureDetector(
          child:
              Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 31),
          onTap: () {
            _goToRestaurantDetails(restaurant);
          },
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, Restaurant restaurant) {
    final alreadyFavorite = favoriteRestaurants.contains(restaurant);

    return Card(
        child: new Column(
      children: <Widget>[
        GestureDetector(
            child: Container(
                margin: EdgeInsets.only(bottom: 15.0),
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(restaurant.imageLink),
                  ),
                )),
            onTap: () {
              _goToRestaurantDetails(restaurant);
            }),
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
                _iconsRow(alreadyFavorite, restaurant)
              ],
            )),
        Container(
            margin: EdgeInsets.all(10),
            child: RestaurantDetailsPage.getAddress(context, restaurant))
      ],
    ));
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
        itemCount: restaurantsList.length,
        itemBuilder: (context, index) {
          return _buildRow(context, restaurantsList[index]);
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
            'FoodZzz',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: RestaurantDetailsPage.darkRedColor,
        ),
        body: _buildList(context),
        drawer:
            DrawerMenu(user: user, favoriteRestaurants: favoriteRestaurants));
  }

}
