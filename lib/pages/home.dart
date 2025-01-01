import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  late Timer timer;
  @override
  void initState() {
    super.initState();

    // Start a periodic timer to update the displayed time
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        data['time'] = _getCurrentTime(); // Update time every second
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  // Function to get the current time as a formatted string
  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour); // Convert to 12-hour format
    return "${hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
  }


  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data:ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    //print(data);

    //set background
    String bgImage = data['isDayTime'] ? 'day.png' : 'night.png';
    Color bgColor = data['isDayTime'] ? Colors.blue : Colors.indigo[700]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child:Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
            )
          ),
        child:Padding(
          padding: const EdgeInsets.fromLTRB(0, 120.0, 0, 0),
          child: Column(
        children: [
          TextButton.icon(onPressed: ()async {
            dynamic result = await Navigator.pushNamed(context, '/location');
            setState(() {
              data={
                'time':result['time'],
                'location':result['location'],
                'isDayTime':result['isDayTime'],
                'flag':result['flag'],
                'date':result['date'],
              };
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
              )
            ],
          ),
          SizedBox(height: 20.0),
          Text(
              data['time'],
          style: TextStyle(
            fontSize: 66.0,
            color: Colors.white,
          ),
          ),
          SizedBox(height:20.0),
          Text(data['date'],
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.white,
          ),),
          SizedBox(height: 20.0),
          Container(
            height: 200,
            width: 200,
            child: AnalogClock(
              decoration: BoxDecoration(
                color: Colors.transparent, // Fully transparent background
                shape: BoxShape.circle,
              ),
              width: 200.0,
              isLive: true,
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
      )
        )
        )
      ),
    );
  }
}
