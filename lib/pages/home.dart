import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String currentTime;
  Map data = {};
  late Timer timer; // Timer to update time every second
  late DateTime locationTime; // Time for the selected location

  @override
  void initState() {
    super.initState();
    // Initialize with default time
    currentTime = "loading";
    locationTime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), updateTime);
  }

  void updateTime(Timer timer) {
    setState(() {
      // Increment the location's time by 1 second
      locationTime = locationTime.add(Duration(seconds: 1));
      currentTime = DateFormat.jm().format(locationTime); // Update the formatted string
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get data passed through route, e.g., location's time
    data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings.arguments as Map? ?? {};

    if (data.containsKey('time') && data['time'] != null && data['time'] is String) {
      try {
        locationTime = DateFormat.jm().parse(data['time']);
      } catch (e) {
        // Handle invalid time format

        locationTime = DateTime.now();
      }
    }
    //print(locationTime);
    return Scaffold(
      backgroundColor: data['isDayTime'] ? Colors.blue : Colors.indigo[700]!,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/${data['isDayTime'] ? 'day.png' : 'night.png'}'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120.0, 0, 0),
            child: Column(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    dynamic result = await Navigator.pushNamed(context, '/location');
                    setState(() {
                      data = {
                        'time': result['time'],
                        'location': result['location'],
                        'isDayTime': result['isDayTime'],
                        'flag': result['flag'],
                        'date': result['date'],
                      };

                      print(data['time']);
                    });
                  },
                  icon: Icon(
                    Icons.edit_location,
                    color: Colors.grey[300],
                  ),
                  label: Text(
                    'Edit Location',
                    style: TextStyle(
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['location'],
                      style: TextStyle(
                        fontSize: 28.0,
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  currentTime,
                  style: TextStyle(
                    fontSize: 66.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  data['date'],
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 200,
                  width: 200,
                  child: AnalogClock(
                    key: ValueKey(locationTime), // Add a ValueKey to force rebuild
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Fully transparent background
                      shape: BoxShape.circle,
                    ),
                    width: 200.0,
                    isLive: true, // Set to false to prevent its internal timer
                    datetime: locationTime, // Use dynamically updated locationTime
                    hourHandColor: Colors.black,
                    minuteHandColor: Colors.black,
                    secondHandColor: Colors.red,
                    showSecondHand: true,
                    numberColor: Colors.black54,
                    showNumbers: true,
                    textScaleFactor: 1.4,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
