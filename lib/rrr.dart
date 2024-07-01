import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class windows extends StatefulWidget {
  const windows({Key? key}) : super(key: key);

  @override
  State<windows> createState() => _windowsState();
}

class _windowsState extends State<windows> {
  TextEditingController _locationController = TextEditingController();
  String _apiKey = "9262644a02aa487288f114630242603";
  String _currentWeather = "";
  String _forecastWeather = "";

  Future<void> _fetchWeatherData(String location) async {
    String currentWeatherUrl =
        'http://api.weatherapi.com/v1/current.json?q=$location&key=$_apiKey&units=metric';
    String forecastWeatherUrl =
        'http://api.weatherapi.com/v1/forecast.json?q=$location&key=$_apiKey&days=5&units=metric';

    try {
      http.Response currentResponse = await http.get(Uri.parse(currentWeatherUrl));
      http.Response forecastResponse = await http.get(Uri.parse(forecastWeatherUrl));

      if (currentResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        Map<String, dynamic> currentData = json.decode(currentResponse.body);
        Map<String, dynamic> forecastData = json.decode(forecastResponse.body);
        setState(() {
          _currentWeather = _parseCurrentWeather(currentData);
          _forecastWeather = _parseForecastWeather(forecastData);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _parseCurrentWeather(Map<String, dynamic> data) {
    Map<String, dynamic> current = data['current'];
    return 'Temperature: ${current['temp_c']}°C\n'
        'Humidity: ${current['humidity']}%\n'
        'Weather: ${current['condition']['text']}\n'
        'Wind Speed: ${current['wind_kph']} km/h';
  }

  String _parseForecastWeather(Map<String, dynamic> data) {
    String forecastText = '';
    List<dynamic> forecastList = data['forecast']['forecastday'];
    for (int i = 0; i < forecastList.length; i++) {
      Map<String, dynamic> forecast = forecastList[i];
      String date = forecast['date'];
      String maxTemp = forecast['day']['maxtemp_c'].toString();
      String minTemp = forecast['day']['mintemp_c'].toString();
      String condition = forecast['day']['condition']['text'];
      forecastText += 'Date: $date\n'
          'Max Temperature: $maxTemp°C\n'
          'Min Temperature: $minTemp°C\n'
          'Condition: $condition\n\n';
    }
    return forecastText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Weather Reports"),
      ) ,
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
            Text('5-Day Weather Forecast:'),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_forecastWeather),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
