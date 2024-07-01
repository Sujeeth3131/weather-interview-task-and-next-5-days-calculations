import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class weatherss extends StatefulWidget {
  const weatherss({super.key});

  @override
  State<weatherss> createState() => _weathersState();
}

class _weathersState extends State<weatherss> {
  TextEditingController _locationController = TextEditingController();

  String _currentWeather = "";
  String _forecastWeather = "";
  String _apiKey = "coimbatore&key=9262644a02aa487288f114630242603";

  Future<void> _fetchWeatherData(String location) async {
    String currentWeatherUrl =
        'http://api.weatherapi.com/v1/current.json?q=$location&appid=$_apiKey&units=metric';
    String forecastWeatherUrl =
        'http://api.weatherapi.com/v1/current.json?q=$location&appid=$_apiKey&units=metric';

    try {
      http.Response currentResponse = await http.get(Uri.parse(currentWeatherUrl));
      http.Response forecastResponse = await http.get(Uri.parse(forecastWeatherUrl));

      if (currentResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        setState(() {
          _currentWeather = currentResponse.body;
          _forecastWeather = forecastResponse.body;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Enter Location (city name or zip code)',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _fetchWeatherData(_locationController.text);
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20.0),
            Text('Current Weather:'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('5-Day Weather Forecast:'),
            ),
          ],
        ),
      ),
    );
  }
}
