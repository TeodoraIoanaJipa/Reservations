import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reservations/database_helper.dart';
import 'package:flutter_reservations/model/reservation.dart';
import 'package:flutter_reservations/model/reservation_dto.dart';
import 'package:flutter_reservations/model/restaurant.dart';
import 'package:flutter_reservations/pages/drawer-menu.dart';
import 'package:flutter_reservations/pages/restaurant_detail_page.dart';
import 'package:flutter_reservations/util/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class ReservationsHistoryList extends StatefulWidget {
  final User? user;
  var favoriteRestaurants = <Restaurant>[];

  ReservationsHistoryList(
      {Key? key, this.user, required this.favoriteRestaurants})
      : super(key: key);
  @override
  _ReservationsHistoryListState createState() => _ReservationsHistoryListState(
      user: user, favoriteRestaurants: favoriteRestaurants);
}

class _ReservationsHistoryListState extends State<ReservationsHistoryList> {
  final User? user;
  var favoriteRestaurants = <Restaurant>[];

  DatabaseHelper databaseHelper = DatabaseHelper();
  var reservations = <Reservation>[];
  var reservationDtos = <ReservationDto>[];

  _ReservationsHistoryListState({this.user, required this.favoriteRestaurants});

  Widget _cancelButton(reservation) {
    var snackBarSuccess = SnackBar(
      content: Text('Felicitări! Rezervarea a fost stearsa.'),
    );
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Utils.darkRedColor, fixedSize: Size(100, 10)),
        onPressed: () {
          final Future<Database> dbFuture = databaseHelper.initializeDatabase();
          dbFuture.then((database) {
            print(reservation);
            databaseHelper.deleteReservation(reservation.id!);
            ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
            updateListView();
          });
        },
        child: Text('Anulează'));
  }

  _numberOfPeople(reservation) {
    return Row(
      children: [
        Icon(
          Icons.people,
          size: 10,
        ),
        Text(
          " ${reservation.numberOfPersons} persoane",
          style: new TextStyle(fontSize: 11.0),
        ),
      ],
    );
  }

  Widget buildReservationCard(BuildContext context, int index) {
    final reservation = reservationDtos[index];

    return Container(
      padding: const EdgeInsets.only(right: 3.0, left: 7.0, top: 2.0),
      height: 300,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                    child: GestureDetector(
                  child: Image.network(
                    reservation.restaurant!.imageLink,
                    fit: BoxFit.cover,
                    width: 140,
                  ),
                  onTap: () {
                    Utils.goToRestaurantDetails(context,
                        reservation.restaurant!, user!, <Restaurant>[]);
                  },
                )),
                Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 100.0,
                      maxWidth: 220.0,
                      minHeight: 16.0,
                      maxHeight: 80.0,
                    ),
                    child: Text(
                      reservation.restaurant!.getName,
                      style: new TextStyle(fontSize: 17.0),
                    ),
                  ),
                ),
                _numberOfPeople(reservation),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 8,
                    ),
                    Text(
                      "${DateFormat('dd/MM/yyyy').format(reservation.reservationDate!).toString()}",
                      style: new TextStyle(fontSize: 11.0),
                    ),
                  ],
                ),
                _cancelButton(reservation)
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Utils.darkRedColor,
              ),
              width: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, Reservation reservation) {
    return Card(
        child: new Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              children: <Widget>[
                Text(
                  "Numar de persoane" + reservation.numberOfPersons.toString(),
                  textAlign: TextAlign.end,
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 26.0,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Text(
                  "Data rezervare" + reservation.reservationDate!,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 22.0,
                    color: Colors.black,
                  ),
                )
              ],
            )),
      ],
    ));
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 350,
            childAspectRatio: 3 / 2.6,
            crossAxisSpacing: 15,
            mainAxisSpacing: 20),
        itemCount: reservationDtos.length,
        itemBuilder: (context, index) {
          return buildReservationCard(context, index);
        });
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Reservation>> restaurantsFuture =
          databaseHelper.getUsersReservations(user!.uid);
      restaurantsFuture.then((reservations) {
        setState(() {
          this.reservations = reservations;
        });
      });
    });

    dbFuture.then((database) {
      Future<List<Restaurant>> restaurantsFuture =
          databaseHelper.getRestaurants();
      restaurantsFuture.then((restaurants) {
        setState(() {
          reservationDtos = convertToReservationDtos(reservations, restaurants);
        });
      });
    });
  }

  List<ReservationDto> convertToReservationDtos(
      List<Reservation> reservations, List<Restaurant> restaurantsList) {
    var reservationDtos = <ReservationDto>[];

    for (var reservation in reservations) {
      Restaurant reservedRestaurant = restaurantsList
          .firstWhere((element) => element.id == reservation.restaurantId);
      ReservationDto reservationDto = new ReservationDto(
          id: reservation.id,
          numberOfPersons: reservation.numberOfPersons,
          reservationDate: DateTime.parse(reservation.reservationDate!),
          requestedDate: DateTime.parse(reservation.requestedDate!),
          reservationHour: reservation.reservationHour,
          restaurant: reservedRestaurant);
      reservationDtos.add(reservationDto);
    }

    return reservationDtos;
  }

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      updateListView();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'FoodZzz',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Utils.darkRedColor,
        ),
        body: _buildGridView(context),
        drawer:
            DrawerMenu(user: user, favoriteRestaurants: favoriteRestaurants));
  }
}
