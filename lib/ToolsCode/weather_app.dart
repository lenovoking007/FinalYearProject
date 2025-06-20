import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  // Replace with your OpenWeatherMap API key
  static const String API_KEY = '255e7829f8ebd0dd297831588d7b8fba'; // Your API Key
  static const String BASE_URL = 'https://api.openweathermap.org/data/2.5';

  Map<String, dynamic>? currentWeather;
  bool isLoading = false;
  String? error;
  String currentCity = 'Rawalpindi'; // Default city
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocationWeather();
  }

  Future<void> _getCurrentLocationWeather() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Check location permission
      var status = await Permission.location.status;
      if (!status.isGranted) {
        await Permission.location.request();
      }

      // Get current position
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Fallback to default city if location service is not enabled
        await _getWeatherByCity(currentCity);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Fallback to default city if permission is denied
          await _getWeatherByCity(currentCity);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low); // Use low accuracy for faster results
      await _getWeatherByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      // Fallback to default city on any location error
      await _getWeatherByCity(currentCity);
    }
  }

  Future<void> _getWeatherByCoordinates(double lat, double lon) async {
    try {
      // Get current weather
      final currentResponse = await http.get(
        Uri.parse('$BASE_URL/weather?lat=$lat&lon=$lon&appid=$API_KEY&units=metric'),
      );

      if (currentResponse.statusCode == 200) {
        final currentData = json.decode(currentResponse.body);

        setState(() {
          currentWeather = currentData;
          currentCity = currentData['name']; // Update current city based on coordinates
          isLoading = false;
          error = null;
        });
      } else {
        throw Exception('Failed to load weather data for coordinates.');
      }
    } catch (e) {
      setState(() {
        error = 'Failed to fetch weather data: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _getWeatherByCity(String cityName) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Get current weather
      final currentResponse = await http.get(
        Uri.parse('$BASE_URL/weather?q=$cityName&appid=$API_KEY&units=metric'),
      );

      if (currentResponse.statusCode == 200) {
        final currentData = json.decode(currentResponse.body);

        setState(() {
          currentWeather = currentData;
          currentCity = currentData['name'];
          isLoading = false;
          error = null;
        });
      } else if (currentResponse.statusCode == 404) {
        throw Exception('City not found. Please try again.');
      } else {
        throw Exception('Failed to load weather data for $cityName');
      }
    } catch (e) {
      setState(() {
        error = 'Failed to fetch weather data: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  String _getWeatherIcon(String iconCode) {
    // Map OpenWeatherMap icons to local icons or use Unicode symbols
    switch (iconCode.substring(0, 2)) {
      case '01':
        return '☀️'; // Clear sky
      case '02':
        return '⛅'; // Few clouds
      case '03':
        return '☁️'; // Scattered clouds
      case '04':
        return '☁️'; // Broken clouds
      case '09':
        return '🌧️'; // Shower rain
      case '10':
        return '🌦️'; // Rain
      case '11':
        return '⛈️'; // Thunderstorm
      case '13':
        return '❄️'; // Snow
      case '50':
        return '🌫️'; // Mist
      default:
        return '🌤️';
    }
  }

  String _formatDate(DateTime date) {
    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width; // Not used in this version

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0066CC),
        elevation: 0,
        title: const Text(
          'Weather',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: _getCurrentLocationWeather,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (searchController.text.isNotEmpty) {
            await _getWeatherByCity(searchController.text);
          } else {
            await _getCurrentLocationWeather();
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Search Section
              Container(
                padding: EdgeInsets.all(screenHeight * 0.02),
                decoration: const BoxDecoration(
                  color: Color(0XFF0066CC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Search city...',
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _getWeatherByCity(value);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          if (searchController.text.isNotEmpty) {
                            _getWeatherByCity(searchController.text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              if (isLoading)
                SizedBox(
                  height: screenHeight * 0.5,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF0066CC)),
                    ),
                  ),
                ),

              if (error != null)
                Container(
                  margin: EdgeInsets.all(screenHeight * 0.02),
                  padding: EdgeInsets.all(screenHeight * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          // Decide whether to retry location or default city
                          if (currentCity.isNotEmpty) {
                            _getWeatherByCity(currentCity); // Retry with the last known city
                          } else {
                            _getCurrentLocationWeather(); // Retry current location
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF0066CC),
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

              if (currentWeather != null && !isLoading) ...[
                // Current Weather Card
                Container(
                  margin: EdgeInsets.all(screenHeight * 0.02),
                  padding: EdgeInsets.all(screenHeight * 0.02),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0XFF0066CC), Color(0XFF004499)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentCity,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatDate(DateTime.now()),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _getWeatherIcon(currentWeather!['weather'][0]['icon']),
                            style: const TextStyle(fontSize: 50),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${currentWeather!['main']['temp'].round()}°C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                currentWeather!['weather'][0]['description']
                                    .toString()
                                    .split(' ')
                                    .map((word) => word[0].toUpperCase() + word.substring(1))
                                    .join(' '),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Feels like',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${currentWeather!['main']['feels_like'].round()}°C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Weather Details Grid
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildWeatherDetailCard(
                        'Humidity',
                        '${currentWeather!['main']['humidity']}%',
                        Icons.water_drop,
                        Colors.blue,
                      ),
                      _buildWeatherDetailCard(
                        'Wind Speed',
                        '${currentWeather!['wind']['speed']} m/s',
                        Icons.air,
                        Colors.green,
                      ),
                      _buildWeatherDetailCard(
                        'Pressure',
                        '${currentWeather!['main']['pressure']} hPa',
                        Icons.compress,
                        Colors.orange,
                      ),
                      _buildWeatherDetailCard(
                        'Visibility',
                        '${(currentWeather!['visibility'] / 1000).toStringAsFixed(1)} km',
                        Icons.visibility,
                        Colors.purple,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetailCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0XFF0066CC),
            ),
          ),
        ],
      ),
    );
  }
}