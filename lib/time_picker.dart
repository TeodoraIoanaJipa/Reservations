// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

// class TimePicker extends StatefulWidget {
//   TimePicker();

//   @override
//   _TimePickerState createState() => _TimePickerState();
// }

// class _TimePickerState extends State<TimePicker> {
//   DateTime _selectedTime = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     return new Container(
//       padding: EdgeInsets.only(top: 50),
//       child: new Column(
//         children: <Widget>[
//           hourMinute(),
//           new Container(
//             margin: EdgeInsets.symmetric(vertical: 50),
//             child: new Text(
//               _selectedTime.hour.toString().padLeft(2, '0') +
//                   ':' +
//                   _selectedTime.minute.toString().padLeft(2, '0') +
//                   ':' +
//                   _selectedTime.second.toString().padLeft(2, '0'),
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget hourMinute() {
//     return new TimePickerSpinner(
//       spacing: 20,
//       minutesInterval: 30,
//       itemHeight: 60,
//       onTimeChange: (time) {
//         setState(() {
//           _selectedTime = time;
//         });
//       },
//     );
//   }

//   Widget hourMinute12HCustomStyle() {
//     return new TimePickerSpinner(
//       is24HourMode: false,
//       normalTextStyle: TextStyle(fontSize: 24, color: Colors.deepOrange),
//       highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.yellow),
//       spacing: 50,
//       itemHeight: 60,
//       isForce2Digits: true,
//       minutesInterval: 15,
//       onTimeChange: (time) {
//         setState(() {
//           _selectedTime = time;
//         });
//       },
//     );
//   }
// }
