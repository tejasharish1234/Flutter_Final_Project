import 'package:flutter/material.dart';
import '../Controller/control.dart';
import '../Model/model.dart';

class CountryScreen extends StatefulWidget {
  final CountryController controller;
  const CountryScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final TextEditingController countrycontroller = TextEditingController();

  void _navigateToDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CountryDetailsScreen(
          controller: widget.controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Country Information App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xff08a4a7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff08a4a7), Color(0xff7DF9FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: countrycontroller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Enter Country Name',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final country = countrycontroller.text.trim();
                if (country.isNotEmpty) {
                  await widget.controller.fetchCountryData(country);
                  // Call the navigation function after data is fetched
                  _navigateToDetails();
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blueAccent,
                backgroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              child: const Text('Search',
                  style: TextStyle(fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}

class CountryDetailsScreen extends StatefulWidget {
  final CountryController controller;
  CountryDetailsScreen({required this.controller});

  @override
  _CountryDetailsScreenState createState() => _CountryDetailsScreenState();
}

class _CountryDetailsScreenState extends State<CountryDetailsScreen> {
  Future<void>? countryData; // Change the type to Future<void>?

  @override
  void initState() {
    super.initState();
    // Don't call fetchCountryData here, it should be called when the button is pressed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.black],
          ),
        ),
        child: SingleChildScrollView(
          child: FutureBuilder<void>( // Change the type to Future<void>
            future: countryData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final countryModel = widget.controller.countryModel;

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 200,
                            width: 300,
                            child: Image.network( // Display flag image using Image.network
                              countryModel.flagpng,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: 100),
                        InfoTile(title: 'Population', value: countryModel.population),
                        InfoTile(title: 'Capital', value: countryModel.capitalcity),
                        InfoTile(title: 'Region', value: countryModel.region),
                        InfoTile(title: 'Currency', value: countryModel.currency),
                        InfoTile(title: 'Language', value: countryModel.language.toString()),
                        InfoTile(title: 'Time Zone', value: countryModel.timezone),
                        InfoTile(title: 'Calling Code', value: '+123'),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Back'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
      subtitle: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 16,
        ),
      ),
    );
  }
}
