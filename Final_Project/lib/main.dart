import '../View/view.dart';
import '../Controller/control.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final CountryController countrycontroller = CountryController();
    return MaterialApp(
      title: 'OpenWeatherAPI',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: CountryScreen(controller: countrycontroller),
    );
  }
}
