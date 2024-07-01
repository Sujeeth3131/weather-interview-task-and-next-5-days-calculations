import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  TextEditingController _locationController = TextEditingController();
  String _apiKey = "9262644a02aa487288f114630242603";
  String _currentWeather = "";

  Future<void> _fetchWeatherData(String location) async {
    String currentWeatherUrl =
        'http://api.weatherapi.com/v1/current.json?q=$location&key=$_apiKey&units=metric';

    try {
      http.Response currentResponse = await http.get(Uri.parse(currentWeatherUrl));

      if (currentResponse.statusCode == 200) {
        Map<String, dynamic> data = json.decode(currentResponse.body);
        setState(() {
          _currentWeather = _parseWeatherData(data);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _parseWeatherData(Map<String, dynamic> data) {
    Map<String, dynamic> current = data['current'];
    return 'Temperature: ${current['temp_c']}°C\n'
        'Humidity: ${current['humidity']}%\n'
        'Weather: ${current['condition']['text']}\n'
        'Wind Speed: ${current['wind_kph']} km/h';
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
                labelText: 'Enter Location (city name)',
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
            Expanded(
              child: SingleChildScrollView(
                child: Text(_currentWeather),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
