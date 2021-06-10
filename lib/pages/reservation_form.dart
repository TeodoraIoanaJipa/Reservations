import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reservations/database_helper.dart';
import 'package:flutter_reservations/model/reservation_dto.dart';
import 'package:flutter_reservations/model/reservation.dart';
import 'package:flutter_reservations/model/restaurant.dart';
import 'package:flutter_reservations/util/utils.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sqflite/sqflite.dart';

class ReservationForm extends StatefulWidget {
  User user;
  Reservation reservation;
  Restaurant restaurant;
  ReservationForm(
      {Key? key,
      required this.user,
      required this.reservation,
      required this.restaurant})
      : super(key: key);

  @override
  _ReservationFormState createState() => _ReservationFormState(
      user: user, reservation: reservation, restaurant: restaurant);
}

class _ReservationFormState extends State<ReservationForm> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  User user;
  Reservation reservation;
  Restaurant restaurant;
  ReservationDto reservationDto = new ReservationDto();

  _ReservationFormState(
      {required this.user,
      required this.reservation,
      required this.restaurant});

  int _currentIntValue = 2;
  int _currentHourPicked = 12;

  var selectedTime;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 90)));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        reservationDto.reservationDate = selectedDate;
        var date =
            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
        _dateController.text = date;
      });
    }
  }

  Widget _datePicker() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          onSaved: (val) {
            reservationDto.reservationDate = selectedDate;
          },
          controller: _dateController,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.only(left: 20.0),
            labelText: "Dată rezervare",
            icon: Icon(Icons.calendar_today),
          ),
          validator: (value) {
            if (value!.isEmpty) return "Data selectată nu este validă";
            return null;
          },
        ),
      ),
    );
  }

  Widget _numberPicker() {
    return NumberPicker(
      value: _currentIntValue,
      minValue: 1,
      maxValue: 14,
      step: 1,
      itemHeight: 80,
      axis: Axis.horizontal,
      onChanged: (value) => setState(() =>
          {_currentIntValue = value, reservationDto.numberOfPersons = value}),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Utils.darkRedColor),
      ),
    );
  }

  void getReservations() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Reservation>> reservationsFuture =
          databaseHelper.getReservations();
      reservationsFuture.then((reservations) {
        setState(() {
          print(reservations);
        });
      });
    });
  }

  void insertReservation(Reservation reservation) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      databaseHelper.insertReservation(reservation);
    });
  }

  int getTime(var hour) {
    var time = hour.split(":")[0];
    int? openingHour = int.tryParse(time);

    if (time.startsWith("00")) {
      openingHour = 24;
    } else if (time.startsWith("0")) {
      openingHour = int.parse(time[1]);
    }

    return openingHour!;
  }

  Widget _hourPicker() {
    var openingHour = getTime(restaurant.openingTime);
    var closingHour = getTime(restaurant.closingTime);

    return NumberPicker(
      value: _currentHourPicked,
      minValue: openingHour,
      maxValue: closingHour,
      step: 1,
      itemHeight: 50,
      axis: Axis.vertical,
      onChanged: (value) => setState(() => {
            _currentHourPicked = value,
            reservationDto.reservationHour = value.toString()
          }),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Utils.darkRedColor),
      ),
    );
  }

  Widget _submitButton() {
    var snackBarSuccess = SnackBar(
      content: Text('Felicitări! Ai rezervat pentru ' +
          reservationDto.numberOfPersons.toString() +
          ' persoane'),
    );

    final snackBarError = SnackBar(
      backgroundColor: Colors.red.shade300,
      content: Text('Vă rugăm completați câmpurile'),
    );

    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: RaisedButton(
        child: Text(
          "Trimite cerere rezervare",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          if (reservationDto.numberOfPersons == null ||
              reservationDto.reservationDate == null ||
              reservationDto.reservationHour == null) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarError);
          } else {
            reservation.numberOfPersons = reservationDto.numberOfPersons;
            reservation.reservationDate =
                reservationDto.reservationDate.toString();
            reservation.reservationHour = reservationDto.reservationHour;
            reservation.requestedDate = DateTime.now().toString();

            print(reservation);
            insertReservation(reservation);
            ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);

            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushReplacement(
                  context, Utils.routeToHistoryPage(user, <Restaurant>[]));
            });
            getReservations();
          }
        },
        color: Utils.darkRedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  showMessage(BuildContext context, String s) {
    final snackBarError = SnackBar(
      backgroundColor: Colors.red.shade300,
      content: Text(s),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarError);
  }

  Future<void> _show() async {
    // List<int> _availableHours = [1, 4, 6, 8, 12];
    // List<int> _availableMinutes = [0, 10, 30, 45, 50];

    // print(restaurant);
    // var hour = restaurant.openingTime.split(':')[0];
    // int openingHour;
    // if (hour[0] == '0') {
    //   openingHour = int.parse(hour[1]);
    //   print(openingHour);
    // }

    // await showCustomTimePicker(
    //         context: context,
    //         // It is a must if you provide selectableTimePredicate
    //         onFailValidation: (context) => print('Unavailable selection'),
    //         initialTime: TimeOfDay(hour: 8, minute: 0),
    //         selectableTimePredicate: (time) =>
    //             time.hour > 7 && time.hour < 14 && time.minute % 10 == 0)
    //     .then((time) => setState(() => selectedTime = time?.format(context)));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 16),
              Text('Selectează numărul de persoane',
                  style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 16),
              _numberPicker(),
              Divider(color: Colors.grey, height: 40),
              Text('Selectează data rezervării',
                  style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 16),
              _datePicker(),
              SizedBox(height: 16),
              Text('Selectează ora rezervării',
                  style: Theme.of(context).textTheme.headline6),
              _hourPicker(),
              _submitButton(),
            ],
          )
        ],
      ),
    );
  }
}
