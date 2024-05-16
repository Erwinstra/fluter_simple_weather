import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  static const API_KEY = 'f58ba2fd36ad8a1e7d10f0fa8da0a17f';

  Future<Weather> getWeather(String cityName) async {
    if (cityName == '') {
      throw Exception('There is no cityName data');
    }

    // get data from api
    var response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$API_KEY&units=metric'));

    // check the status code
    if (response.statusCode == 200) {
      // the data is sent to weather model
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      // throw an exception if status code isnt 200
      throw Exception(
          'Failed to get the weather data, code = ${response.statusCode}');
    }
  }

  Future<String> getCurrentCity() async {
    // bool serviceEnabled;
    LocationPermission permission;

    // // Test if location services are enabled.
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    return placemarks[4].locality ?? '';
  }
}
