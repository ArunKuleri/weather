import 'package:flutter/material.dart';
import 'package:weather/api.dart';
import 'package:weather/weathermodel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ApiResponse? response;
  bool inProgress = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchWidget(),
              const SizedBox(
                height: 20,
              ),
              if (inProgress)
                const CircularProgressIndicator()
              else
                _buildWeatherWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return SearchBar(
      hintText: "Serach any location",
      onSubmitted: (value) {
        _getWeatherData(value);
      },
    );
  }

  Widget _buildWeatherWidget() {
    if (response == null) {
      return const Text("Search for the locaion to get weather data");
    } else {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 50,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        response?.location?.name ?? "".split('').join('\n'),
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    response?.location?.country ?? "",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${response?.current?.tempC.toString() ?? ""} °C",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    (response?.current?.condition?.text.toString() ?? ""),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  _getWeatherData(String location) async {
    setState(() {
      inProgress = true;
    });
    try {
      response = await WeatherApi().getCurrentWeather(location);
    } catch (e) {
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
