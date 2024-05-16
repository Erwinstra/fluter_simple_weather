import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _ws = WeatherService();
  Weather? _weather;

  void _fetchWeather() async {
    String location = await _ws.getCurrentCity();

    Weather weather = await _ws.getWeather(location);

    setState(() {
      _weather = weather;
    });
  }

  String getWeatherAnimation(String mainCondition) {
    print(mainCondition);
    switch (mainCondition) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 33, 33, 33),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.location_pin,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    _weather?.cityName ?? 'Loading city..',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              Lottie.asset(
                getWeatherAnimation(_weather?.mainCondition.toLowerCase() ??
                    'Loading weather..'),
              ),
              Text(
                '${_weather?.temperature.round()}°C',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
