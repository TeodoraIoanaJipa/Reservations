import 'package:firebase_auth/firebase_auth.dart';
// import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reservations/database_helper.dart';
import 'package:flutter_reservations/model/reservation_dto.dart';
import 'package:flutter_reservations/model/reservation.dart';
import 'package:flutter_reservations/pages/restaurant_detail_page.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sqflite/sqflite.dart';

class ReservationForm extends StatefulWidget {
  Reservation reservation;
  ReservationForm({Key? key, required this.reservation}) : super(key: key);

  @override
  _ReservationFormState createState() =>
      _ReservationFormState(reservation: reservation);
}

class _ReservationFormState extends State<ReservationForm> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Reservation reservation;
  ReservationDto reservationDto = new ReservationDto();

  _ReservationFormState({required this.reservation});

  int _currentIntValue = 2;
  late NumberPicker integerNumberPicker;
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
        border: Border.all(color: RestaurantDetailsPage.darkRedColor),
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

  Widget _submitButton() {
    var snackBarSuccess = SnackBar(
      content: Text('Felicitări! Ai rezervat pentru ' +
          reservationDto.numberOfPersons.toString() +
          ' persoane'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
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
              reservationDto.reservationDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarError);
          } else {
            reservation.numberOfPersons = reservationDto.numberOfPersons;
            reservation.reservationDate =
                reservationDto.reservationDate.toString();
            reservation.reservationHour = "8:00";
            reservation.requestedDate = DateTime.now().toString();

            print(reservation);
            insertReservation(reservation);
            ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
            getReservations();
          }
        },
        color: RestaurantDetailsPage.darkRedColor,
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

    // final TimeOfDay? result = await showTimePicker(
    //   context: context,
    //   // It is a must if you provide selectableTimePredicate
    //   initialTime: TimeOfDay(
    //       hour: _availableHours.first, minute: _availableMinutes.first),
    // );
    // if (result != null) {
    //   setState(() {
    //     selectedTime = result.format(context);
    //   });
    // }
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
              ElevatedButton(onPressed: _show, child: Text('Ora rezervarii')),
              _submitButton(),
            ],
          )
        ],
      ),
    );
  }
}
