
class Reservation {
  late int? id;
  late int? numberOfPersons;
  late String? reservationDate;
  late String? reservationHour;
  late String? requestedDate;
  late int? restaurantId;
  late String? userId;

  Reservation(
      {this.id,
      this.numberOfPersons,
      this.reservationDate,
      this.reservationHour,
      this.requestedDate,
      this.restaurantId,
      this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number_of_persons': numberOfPersons,
      'reservation_date': reservationDate,
      'reservation_hour': reservationHour,
      'requested_date': requestedDate,
      'restaurant_id': restaurantId,
      'user_id': userId,
    };
  }

  static Reservation fromMapObject(Map<String, dynamic> map) {
    return Reservation(
        id: map['id'],
        numberOfPersons: map['number_of_persons'],
        reservationDate: map['reservation_date'],
        reservationHour: map['reservation_hour'],
        requestedDate: map['requested_date'],
        restaurantId: map['restaurant_id'],
        userId: map['user_id'],
        );
  }

  @override
  String toString() {
    return 'Reservation{id: $id, numberOfPersons: $numberOfPersons, reservationDate: $reservationDate' +
        ', restaurantId: $restaurantId}, userId: $userId}';
  }
}
