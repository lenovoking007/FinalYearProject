import 'package:flutter/material.dart';

class WeatherForecastPage extends StatefulWidget {
  const WeatherForecastPage({Key? key}) : super(key: key);

  @override
  State<WeatherForecastPage> createState() => _WeatherForecastPageState();
}

class _WeatherForecastPageState extends State<WeatherForecastPage> {
  String selectedCity = 'Loralai';
  String temperature = '25°C';
  String weatherDescription = 'Sunny';
  String humidity = '65%';
  String windSpeed = '10 km/h';
  String pressure = '1015 hPa';

  final List<String> cities = ['Loralai', 'Karachi', 'Lahore', 'Islamabad'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Weather Forecast",
          style: TextStyle(
            color: Color(0XFF0066CC),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0XFF0066CC)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            _buildCitySelector(),
            const SizedBox(height: 20),
            _buildWeatherInfo(),
            const SizedBox(height: 20),
            _buildAdditionalInfo(),
            const SizedBox(height: 20),
            _buildHourlyForecast(),  // Added Hourly Forecast
          ],
        ),
      ),
    );
  }

  // City Selector Dropdown
  Widget _buildCitySelector() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          Icons.location_city,
          color: const Color(0XFF0066CC),
        ),
        title: const Text(
          'Select City',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: DropdownButton<String>(
          isExpanded: true,
          value: selectedCity,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Color(0XFF0066CC)),
          underline: Container(
            height: 2,
            color: Color(0XFF0066CC),
          ),
          onChanged: (String? newValue) {
            setState(() {
              selectedCity = newValue!;
            });
          },
          items: cities.map<DropdownMenuItem<String>>((String city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(city),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Weather Information Card
  Widget _buildWeatherInfo() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          Icons.wb_sunny,
          color: const Color(0XFF0066CC),
        ),
        title: const Text(
          'Current Weather',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temperature: $temperature',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              'Weather: $weatherDescription',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // Additional Weather Information (Humidity, Wind Speed, etc.)
  Widget _buildAdditionalInfo() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Humidity", humidity),
            const SizedBox(height: 10),
            _buildInfoRow("Wind Speed", windSpeed),
            const SizedBox(height: 10),
            _buildInfoRow("Pressure", pressure),
          ],
        ),
      ),
    );
  }

  // Helper Method to Display Information Rows (e.g., Humidity, Wind Speed, etc.)
  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  // Hourly Forecast Card (Details for different times)
  Widget _buildHourlyForecast() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hourly Forecast',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0XFF0066CC),
              ),
            ),
            const SizedBox(height: 10),
            _buildHourlyRow("8:00 AM", "10°C", Icons.wb_sunny),
            _buildHourlyRow("10:00 AM", "12°C", Icons.wb_sunny),
            _buildHourlyRow("12:00 PM", "15°C", Icons.wb_sunny),
            _buildHourlyRow("2:00 PM", "18°C", Icons.wb_sunny),
            _buildHourlyRow("4:00 PM", "17°C", Icons.wb_sunny),
            _buildHourlyRow("6:00 PM", "14°C", Icons.nightlight_round),
          ],
        ),
      ),
    );
  }

  // Helper Method for Hourly Forecast Row
  Widget _buildHourlyRow(String time, String temperature, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(
                icon,
                color: Color(0XFF0066CC),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                temperature,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
