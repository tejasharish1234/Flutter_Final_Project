import 'dart:async';
import 'dart:convert';
import '../Model/model.dart';
import 'package:http/http.dart' as http;

class CountryController {
  final CountryModel countryModel = CountryModel();

  Future<void> fetchCountryData(String country) async {
    try {
      final url = Uri.parse('https://restcountries.com/v3.1/name/$country');
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      countryModel.capitalcity = data[0]['capital'][0];
      countryModel.continent = data[0]['continents'][0];
      countryModel.region = data[0]['region'];
      countryModel.subregion = data[0]['subregion'];
      countryModel.currency =
      "${data[0]['currencies']['INR']['name']}: ${data[0]['currencies']['INR']['symbol']}";
      countryModel.flagpng = data[0]['flags']['png'];
      countryModel.mapslink = data[0]['maps']['googleMaps'];
      countryModel.population = (data[0]['population']).toString();
      countryModel.timezone = data[0]['timezones'][0];
      countryModel.language = data[0]['languages'];
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
