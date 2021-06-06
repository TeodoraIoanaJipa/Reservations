
class Reservation {
  late int? id;
  late int? numberOfPersons;
  late DateTime? reservationDate;
  late String? reservationHour;
  late DateTime? requestedDate;
  late int? restaurantId;
  late int? userId;

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
      'numberOfPersons': numberOfPersons,
      'reservationDate': reservationDate,
      'reservationHour': reservationHour,
      'requestedDate': requestedDate,
      'restaurantId': restaurantId,
      'userId': userId,
    };
  }

  static Reservation fromMapObject(Map<String, dynamic> map) {
    return Reservation(
        id: map['id'],
        numberOfPersons: map['number_of_persons'],
        reservationDate: DateTime.parse(map['reservation_date']),
        reservationHour: map['reservation_hour'],
        requestedDate: DateTime.parse(map['requested_date']),
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
