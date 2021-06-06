
class Restaurant {
  int id;
  String name;
  String description;
  String openingTime;
  String closingTime;
  String priceCategory;
  String imageLink;
  String address;
  double latitude;
  double longitude;

  Restaurant(
      {required this.id,
      required this.name,
      required this.description,
      required this.openingTime,
      required this.closingTime,
      required this.priceCategory,
      required this.imageLink,
      required this.address,
      required this.latitude,
      required this.longitude});

  int get getId {
    return id;
  }

  String get getName {
    return name;
  }

  set setId(int givenId) {
    id = givenId;
  }

  set setName(String givenName) {
    name = givenName;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'priceCategory': priceCategory,
      'imageLink': imageLink,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static Restaurant fromMapObject(Map<String, dynamic> map) {
    return Restaurant(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        openingTime: map['opening_time'],
        closingTime: map['closing_time'],
        priceCategory: map['price_category'],
        imageLink: map['image_link'],
        address: map['address'],
        latitude: map['latitude'],
        longitude: map['longitude']);
  }

  @override
  String toString() {
    return 'Restaurant{id: $id, name: $name, description: $description' +
        ', openingTime: $openingTime}, closingTime: $closingTime}';
  }
}
