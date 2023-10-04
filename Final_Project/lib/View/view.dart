import 'package:flutter/material.dart';
import 'package:for_the_love_of_god_pls_work/Controller/control.dart';

class CountryScreen extends StatefulWidget {
  final CountryController controller;
  const CountryScreen({super.key, required this.controller});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
