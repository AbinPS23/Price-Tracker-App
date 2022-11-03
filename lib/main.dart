import 'package:flutter/material.dart';
import 'package:grocery_price_tracker_app/pages/homePage.dart';

void main(){
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      title: "Products Price Tracker",
      home: HomePage(),
    );
  }
}