import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reservations/authentication.dart';
import 'package:flutter_reservations/pages/login_page.dart';
import 'package:flutter_reservations/model/restaurant.dart';
import 'package:flutter_reservations/pages/restaurantsList.dart';

class DrawerMenu extends StatelessWidget {
  final User? user;
  var favoriteRestaurants = <Restaurant>[];

  DrawerMenu({required this.user, required this.favoriteRestaurants});

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _routeToRestaurantsPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          RestaurantsList(user: user),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget _getGoogleImage() {
    return (user != null && user!.photoURL != null)
        ? ClipOval(
            child: Material(
              color: Colors.grey.withOpacity(0.3),
              child: Image.network(
                user!.photoURL!,
                fit: BoxFit.fitHeight,
              ),
            ),
          )
        : ClipOval(
            child: Material(
              color: Colors.grey.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
          );
  }

  void _getFavoriteRestaurants(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = favoriteRestaurants.map(
            (Restaurant pair) {
              return ListTile(
                title: Text(
                  pair.name,
                  style: TextStyle(fontSize: 26.0),
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: Text('Favorites'),
              backgroundColor: Colors.orange,
            ),
            body: ListView(
              children: divided,
              padding: EdgeInsets.only(top: 15),
            ),
          );
        },
      ),
    );
  }

  Widget _getDrawer(BuildContext context) {
    if (user != null) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber.shade600,
              ),
              accountName: Text(
                user!.displayName ?? '',
                style: TextStyle(color: Colors.black),
              ),
              accountEmail: Text(user!.email ?? ''),
              currentAccountPicture: _getGoogleImage(),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Restaurants"),
              onTap: () {
                Navigator.pushReplacement(context, _routeToRestaurantsPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Restaurante favorite"),
              onTap: () {
                _getFavoriteRestaurants(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                await Authentication.signOut(context: context);
                Navigator.pushReplacement(context, _routeToSignInScreen());
              },
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.login),
              title: Text("Please login"),
              onTap: () {
                Navigator.pushReplacement(context, _routeToSignInScreen());
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getDrawer(context);
  }
}
