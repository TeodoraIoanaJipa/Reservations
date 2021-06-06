import 'package:flutter_reservations/model/reservation.dart';
import 'package:flutter_reservations/model/restaurant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String restaurantsTableName = 'restaurants';
  String reservationsTableName = 'reservations';

  String colId = 'id';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = 'foodZZZ.db';

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/insertRestaurants.txt');
  }

  void _createDb(Database db, int newVersion) async {
    var insertRestaurantsQuery = await loadAsset();

    await db.execute(
      'CREATE TABLE $restaurantsTableName(id INTEGER PRIMARY KEY, name TEXT, ' +
          'description TEXT, opening_time TEXT, closing_time TEXT, price_category TEXT, ' +
          'image_link TEXT, address TEXT, latitude REAL, longitude REAL)',
    );

    await db.execute(
        'CREATE TABLE $reservationsTableName(id INTEGER PRIMARY KEY, number_of_persons INTEGER, reservation_date TEXT, reservation_hour TEXT, requested_date TEXT, restaurant_id INTEGER, user_id INTEGER);');

    await db.execute(insertRestaurantsQuery);
  }

  Future<List<Map<String, dynamic>>> getRestaurantsList() async {
    Database db = await this.database;

    var result = await db.query(restaurantsTableName, orderBy: 'name ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getReservationsList() async {
    Database db = await this.database;

    return await db.query(reservationsTableName, orderBy: 'id ASC');
  }

  Future<int> insertReservation(Reservation reservation) async {
    Database db = await this.database;
    var result = await db.insert(reservationsTableName, reservation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> updateReservation(Reservation reservation) async {
    var db = await this.database;
    var result = await db.update(reservationsTableName, reservation.toMap(),
        where: '$colId = ?', whereArgs: [reservation.id]);
    return result;
  }

  Future<int> deleteReservation(int id) async {
    var db = await this.database;
    int result = await db
        .rawDelete('DELETE FROM $reservationsTableName WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $reservationsTableName');
    int result = Sqflite.firstIntValue(x)!;
    return result;
  }

  Future<List<Restaurant>> getRestaurants() async {
    var restaurants = await getRestaurantsList();
    int count = restaurants.length;

    var reservations = await getReservationsList();
    print(reservations);

    return List.generate(count, (i) {
      return Restaurant.fromMapObject(restaurants[i]);
    });
  }
}
