import 'dart:convert';

import 'package:ost_weather/DataLayer/ExtendedForecast.dart';
import 'package:ost_weather/DataLayer/HourlyForecast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class WeatherClient {
  final _path = "/data/2.5";
  final _host = "api.openweathermap.org";
  final _apiKey = "aa1dc17924497b3c41d3919fc5a27654";

  Future<HourlyForecast> getHourlyForecast(String zipcode) async {
    final queryParams = {'zip': '$zipcode', 'APPID': '$_apiKey', 'units': 'imperial'};

    final uri = Uri.https(_host, _path + "/forecast", queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return HourlyForecast.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to get weather: ${response.reasonPhrase}");
    }
  }

  Future<HourlyForecast> getHourlyForecastFromFile() async {
    String weather = await rootBundle.loadString('assets/weather.json');

    return HourlyForecast.fromJson(json.decode(weather));
  }

  Future<ExtendedForecast> getExtendedForecastFromFile() async {
    String weather = await rootBundle.loadString('assets/extendedForecast.json');

    return ExtendedForecast.fromJson(json.decode(weather));
  }
}
