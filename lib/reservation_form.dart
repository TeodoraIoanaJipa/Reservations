import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reservations/model/reservation.dart';
import 'package:numberpicker/numberpicker.dart';

class ReservationForm extends StatefulWidget {
  ReservationForm({Key? key}) : super(key: key);

  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Reservation reservation = new Reservation();

  int _currentIntValue = 2;
  late NumberPicker integerNumberPicker;
  String darkRed = "#b41700".replaceAll('#', '0xff');

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 90)));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var date =
            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
        _dateController.text = date;
      });
  }

  Widget _datePicker() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          onSaved: (val) {
            reservation.reservationDate = selectedDate;
          },
          controller: _dateController,
          decoration: InputDecoration(
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
          {_currentIntValue = value, reservation.numberOfPersons = value}),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(int.parse(darkRed))),
      ),
    );
  }

  Widget _submitButton() {
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
        onPressed: () {},
        color: Color(int.parse(darkRed)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
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
              Divider(color: Colors.grey, height: 32),
              Text('Selectează data rezervării',
                  style: Theme.of(context).textTheme.headline6),
              _datePicker(),
              _submitButton(),
            ],
          )
        ],
      ),
    );
  }
}
