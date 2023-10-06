import 'dart:async';
import 'dart:convert';
import '../Model/model.dart';
import 'package:http/http.dart' as http;

class CountryController {
  final CountryModel countryModel = CountryModel();

  Future<String> fetchCountryData(String country) async {
    try {
      final url = Uri.parse('https://restcountries.com/v3.1/name/$country');
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      countryModel.officialname = data[0]['name']['official'];
      countryModel.capitalcity = data[0]['capital'][0];
      countryModel.continent = data[0]['continents'][0];
      countryModel.subregion = data[0]['subregion'];
      // countryModel.currency =
      //     "${data[0]['currencies']['INR']['name']}: ${data[0]['currencies']['INR']['symbol']}";
      Map x = data[0]['currencies'];
      for (var i in x.entries) {
        countryModel.currency = i.value['name'];
      }
      countryModel.flagpng = data[0]['flags']['png'];
      countryModel.population = (data[0]['population']).toString();
      countryModel.timezone = data[0]['timezones'][0];
      Map language = data[0]['languages'];
      for (var i in language.entries) {
        countryModel.language += '${i.value}\n';
      }
      return 'true';
    } catch (e) {
      return 'false';
    }
  }
}
