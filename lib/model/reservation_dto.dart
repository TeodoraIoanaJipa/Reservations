
import 'package:flutter_reservations/model/restaurant.dart';

class ReservationDto {
  late int? id;
  late int? numberOfPersons;
  late DateTime? reservationDate;
  late String? reservationHour;
  late DateTime? requestedDate;
  late Restaurant? restaurant;
  late int? userId;

  ReservationDto(
      {this.id,
      this.numberOfPersons,
      this.reservationDate,
      this.reservationHour,
      this.requestedDate,
      this.restaurant,
      this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numberOfPersons': numberOfPersons,
      'reservationDate': reservationDate,
      'reservationHour': reservationHour,
      'requestedDate': requestedDate,
      'restaurant': restaurant,
      'userId': userId,
    };
  }

  // static ReservationDto fromMapObject(Map<String, dynamic> map) {
  //   return ReservationDto(
  //       id: map['id'],
  //       numberOfPersons: map['number_of_persons'],
  //       reservationDate: DateTime.parse(map['reservation_date']),
  //       reservationHour: map['reservation_hour'],
  //       requestedDate: DateTime.parse(map['requested_date']),
  //       restaurantId: map['restaurant_id'],
  //       userId: map['user_id'],
  //       );
  // }

  @override
  String toString() {
    return 'Reservation{id: $id, numberOfPersons: $numberOfPersons, reservationDate: $reservationDate' +
        ', restaurant: $restaurant}, userId: $userId}';
  }
}
