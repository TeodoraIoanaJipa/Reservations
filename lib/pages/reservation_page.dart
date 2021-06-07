import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reservations/model/reservation_dto.dart';
import 'package:flutter_reservations/model/reservation.dart';
import 'package:flutter_reservations/model/restaurant.dart';
import 'package:flutter_reservations/pages/restaurant_detail_page.dart';
import 'package:flutter_reservations/reservation_form.dart';

class ReservationPage extends StatelessWidget {
  Restaurant selectedRestaurant;
  User? user;

  ReservationPage({required this.selectedRestaurant, required this.user});

  @override
  Widget build(BuildContext context) {
    Reservation reservation = new Reservation();
    reservation.userId = user!.uid;
    reservation.restaurantId = selectedRestaurant.getId;

    return MaterialApp(
      title: 'Reservation',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Rezerva acum la " + selectedRestaurant.name,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: RestaurantDetailsPage.darkRedColor,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReservationForm(
              reservation: reservation,
            ),
          ),
        ),
      ),
    );
  }
}
