import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reservations/model/restaurant.dart';
import 'package:flutter_reservations/pages/reservations_history.dart';
import 'package:flutter_reservations/pages/restaurant_detail_page.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  static Color darkRedColor =
      Color(int.parse("#b41700".replaceAll('#', '0xff')));

  static Route routeToHistoryPage(User user, List<Restaurant> favoriteRestaurants) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ReservationsHistoryList(
              user: user, favoriteRestaurants: favoriteRestaurants),
    );
  }

  static Widget getAddress(BuildContext context, Restaurant restaurant) {
    return Container(
      child: new Row(
        children: <Widget>[
          new Icon(Icons.location_on, color: darkRedColor),
          new Text(
            restaurant.address,
            maxLines: 2,
            style: GoogleFonts.libreBaskerville(
              color: darkRedColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  static Widget goToIcon(BuildContext context, Restaurant restaurant,
      User currentUser, var favoriteRestaurants) {
    return GestureDetector(
      child: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 31),
      onTap: () {
        goToRestaurantDetails(
            context, restaurant, currentUser, favoriteRestaurants);
      },
    );
  }

  static void goToRestaurantDetails(BuildContext context, Restaurant restaurant,
      User currentUser, var restaurants) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RestaurantDetailsPage(
                  restaurant: restaurant,
                  user: currentUser,
                  favoriteRestaurants: restaurants,
                )));
  }

  static Widget restaurantImage(
      BuildContext context, Restaurant restaurant, User user, var restaurants) {
    return GestureDetector(
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
          goToRestaurantDetails(context, restaurant, user, restaurants);
        });
  }
}
