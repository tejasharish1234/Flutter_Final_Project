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
  bool isFetchingData = false;

  void _navigateToDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CountryDetailsScreen(
          controller: widget.controller,
        ),
      ),
    );
    isFetchingData = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Information App',
            style: GoogleFonts.lora(fontWeight: FontWeight.bold, fontSize: 28)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(194, 98, 53, 6),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_1.jpg'),
              fit: BoxFit.fitHeight,
            ),
            color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            countrycontroller.text.isNotEmpty &&
                    widget.controller.countryModel.officialname.isEmpty &&
                    !isFetchingData
                ? Column(
                    children: [
                      Text(
                          'Country not found. Please enter a valid country name.',
                          style: GoogleFonts.lora(
                            color: const Color.fromARGB(255, 255, 0,
                                0), // Customize the color as you like.
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 30.0)
                    ],
                  )
                : Container(),
            Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: TextField(
                  controller: countrycontroller,
                  style: GoogleFonts.lora(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter Country Name',
                    labelStyle: GoogleFonts.lora(color: Colors.white),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                )),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isFetchingData
                  ? null
                  : () async {
                      final country = countrycontroller.text.trim();
                      if (country.isNotEmpty) {
                        isFetchingData = true;

                        String works =
                            (await widget.controller.fetchCountryData(country))
                                .toString();
                        if (works == 'true') {
                          _navigateToDetails();
                        } else {
                          isFetchingData = false;
                        }
                      }
                      setState(() {});
                    },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(15, 125, 125, 125),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Search',
                style: GoogleFonts.lora(fontSize: 18),
              ),
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
  CountryDetailsScreenState createState() => CountryDetailsScreenState();
}

class CountryDetailsScreenState extends State<CountryDetailsScreen> {
  Future<void>? countryData; // Change the type to Future<void>?

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Info',
            style: GoogleFonts.lora(fontWeight: FontWeight.bold, fontSize: 28)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(194, 98, 53, 6),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg_1.jpg'), fit: BoxFit.fill),
            color: Colors.black),
        child: SingleChildScrollView(
          child: FutureBuilder<void>(
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
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center alignment
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 200,
                            width: 300,
                            child: Image.network(
                              countryModel.flagpng,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        _InfoTile(
                          title: 'Official Name',
                          value: countryModel.officialname,
                        ),
                        _InfoTile(
                          title: 'Capital',
                          value: countryModel.capitalcity,
                        ),
                        _InfoTile(
                          title: 'Region',
                          value: countryModel.subregion,
                        ),
                        _InfoTile(
                          title: 'Language',
                          value: countryModel.language,
                        ),
                        _InfoTile(
                          title: 'Population',
                          value: countryModel.population,
                        ),
                        _InfoTile(
                          title: 'Currency',
                          value: countryModel.currency,
                        ),
                        _InfoTile(
                          title: 'Time Zone',
                          value: countryModel.timezone,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              countryModel.language = '';
                              countryModel.officialname = '';
                            },
                            child: Text('Back',
                                style: GoogleFonts.lora(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
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

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(100, 98, 53, 6),
          borderRadius: BorderRadius.circular(20.0)),
      width: 400,
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Vertical spacing
      child: ListTile(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.ebGaramond(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        subtitle: Text(
          value,
          textAlign: TextAlign.center,
          style: GoogleFonts.ebGaramond(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
