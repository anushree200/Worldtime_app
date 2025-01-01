import 'package:flutter/material.dart';
import 'package:worldtime/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setupWorldTime() async {
    WorldTime instance = WorldTime(location: 'India', flag:'india.png',url:'Asia/Kolkata');
    await instance.getTime();//does this in background
    Navigator.pushReplacementNamed(context, '/home',arguments: {
      'location':instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDayTime':instance.isDayTime,
      'date':instance.date,
    });
  }
  int count=0;
  @override
  void initState() {
    super.initState();
    //print('init state function ran');
    setupWorldTime();
    print('hey there');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SpinKitWanderingCubes(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
