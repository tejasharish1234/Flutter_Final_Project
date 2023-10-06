import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Controller/control.dart';

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
        title: Text('Country Information App',
            style: GoogleFonts.lora(fontWeight: FontWeight.bold, fontSize: 28)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 90, 91),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 2, 90, 91),
              Color.fromARGB(255, 44, 183, 190)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: countrycontroller,
              style: GoogleFonts.lora(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter Country Name',
                labelStyle: GoogleFonts.lora(color: Colors.white),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: const OutlineInputBorder(
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
              child: Text('Search',
                  style: GoogleFonts.lora(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class CountryDetailsScreen extends StatefulWidget {
  final CountryController controller;
  const CountryDetailsScreen({super.key, required this.controller});

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
        title: const Text('Country Details'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.black],
          ),
        ),
        child: SingleChildScrollView(
          child: FutureBuilder<void>(
            // Change the type to Future<void>
            future: countryData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
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
                            child: Image.network(
                              // Display flag image using Image.network
                              countryModel.flagpng,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                        InfoTile(
                            title: 'Population',
                            value: countryModel.population),
                        InfoTile(
                            title: 'Capital', value: countryModel.capitalcity),
                        InfoTile(title: 'Region', value: countryModel.region),
                        InfoTile(
                            title: 'Currency', value: countryModel.currency),
                        InfoTile(
                            title: 'Language', value: countryModel.language),
                        InfoTile(
                            title: 'Time Zone', value: countryModel.timezone),
                        const InfoTile(title: 'Calling Code', value: '+123'),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Back'),
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

  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.robotoSlab(
          color: Colors.yellow,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
      subtitle: Text(
        value,
        textAlign: TextAlign.center,
        style: GoogleFonts.robotoSlab(
          color: Colors.yellow,
          fontSize: 16,
        ),
      ),
    );
  }
}
