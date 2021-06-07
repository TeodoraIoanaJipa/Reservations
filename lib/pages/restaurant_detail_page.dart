import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reservations/maps-location.dart';
import 'package:flutter_reservations/model/restaurant.dart';
import 'package:flutter_reservations/pages/drawer-menu.dart';
import 'package:flutter_reservations/pages/reservation_page.dart';
import 'package:google_fonts/google_fonts.dart';



class RestaurantDetailsPage extends StatelessWidget {
  
  final Restaurant restaurant;

  final User? user;

  var favoriteRestaurants = <Restaurant>[];

  final String buttonText = "Rezervă o masă";

  static Color darkRedColor =
      Color(int.parse("#b41700".replaceAll('#', '0xff')));

  RestaurantDetailsPage(
      {Key? key,
      required this.restaurant,
      required this.user,
      required this.favoriteRestaurants})
      : super(key: key);

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

  Widget getDetailsText(BuildContext context) {
    var restaurantName = Flexible(
        child: Text(
      restaurant.name,
      maxLines: 2,
      style: GoogleFonts.libreBaskerville(
        color: Colors.black,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    ));

    return Column(
      children: <Widget>[
        Row(
          children: [
            Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.fastfood_rounded,
                  color: Colors.black,
                  size: 40.0,
                )),
            restaurantName
          ],
        ),
        Container(
          width: 220.0,
          child: new Divider(
            color: darkRedColor,
            thickness: 2,
          ),
        ),
        Container(
          child: getAddress(context, restaurant),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Row(
                      children: [
                        Icon(Icons.schedule_rounded, color: darkRedColor),
                        Text(
                          restaurant.openingTime + "-" + restaurant.closingTime,
                          style: TextStyle(color: darkRedColor),
                        )
                      ],
                    ))),
            Expanded(
                flex: 3,
                child: Container(
                  child: new Text(
                    "\$" + restaurant.priceCategory,
                    style: TextStyle(color: darkRedColor),
                  ),
                ))
          ],
        ),
      ],
    );
  }

  Widget _restaurantImage(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 15.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(restaurant.imageLink),
            ))),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _infoContent(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Center(
        child: getDetailsText(context),
      ),
    );
  }

  Widget _descriptionContent(BuildContext context) {
    final descriptionText = Padding(
      child: Text(
        restaurant.description,
        textAlign: TextAlign.justify,
        style: GoogleFonts.libreBaskerville(fontSize: 13.0),
      ),
      padding: EdgeInsets.all(15.0),
    );

    final reservationButton = Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      width: double.infinity,
      child: RaisedButton(
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReservationPage(
                        selectedRestaurant: restaurant,
                        user: user
                      )));
        },
        color: darkRedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(12),
      child: Center(
        child: Column(
          children: <Widget>[descriptionText, reservationButton],
        ),
      ),
    );
  }

  Widget _mapsLocation() {
    return Container(
        height: 300,
        width: 400,
        margin: EdgeInsets.only(bottom: 20.0),
        alignment: Alignment.center,
        child: MapsRestaurantLocation(
            latitude: restaurant.latitude, longitude: restaurant.longitude),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(0),
            child: new CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 220,
                  backgroundColor: Colors.black,
                  flexibleSpace: FlexibleSpaceBar(
                    background:
                        Image.network(restaurant.imageLink, fit: BoxFit.cover),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _infoContent(context),
                    _descriptionContent(context),
                    _mapsLocation(),
                  ]),
                )
              ],
            )),
        drawer: DrawerMenu(
          user: user,
          favoriteRestaurants: favoriteRestaurants,
        ));
  }
}
