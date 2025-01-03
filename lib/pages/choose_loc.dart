import 'package:flutter/material.dart';
import 'package:worldtime/services/world_time.dart';
class ChooseLoc extends StatefulWidget {
  const ChooseLoc({super.key});

  @override
  State<ChooseLoc> createState() => _ChooseLocState();
}

class _ChooseLocState extends State<ChooseLoc> {

  List<WorldTime> locations = [
    WorldTime(url: 'Europe/London', location: 'London', flag: 'uk.png'),
    WorldTime(url: 'Europe/Berlin', location: 'Athens', flag: 'greece.png'),
    WorldTime(url: 'Africa/Cairo', location: 'Cairo', flag: 'egypt.png'),
    WorldTime(url: 'Africa/Nairobi', location: 'Nairobi', flag: 'kenya.png'),
    WorldTime(url: 'America/Chicago', location: 'Chicago', flag: 'usa.png'),
    WorldTime(url: 'America/New_York', location: 'New York', flag: 'usa.png'),
    WorldTime(url: 'Asia/Seoul', location: 'Seoul', flag: 'south_korea.png'),
    WorldTime(url: 'Asia/Jakarta', location: 'Jakarta', flag: 'indonesia.png'),
  ];

  void updateTime(index) async {
    WorldTime instance = locations[index];
    await instance.getTime();
    //navigate to home screen
    Navigator.pop(context, {
      'location':instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDayTime':instance.isDayTime,
      'date':instance.date,
    });
  }
  @override
  Widget build(BuildContext context) {
   // print('build state function ran');
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('choose a location',
        style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView.builder(
          itemCount : locations.length,
          itemBuilder: (context, index){
            return Padding(
              padding : const EdgeInsets.symmetric(vertical: 1.0,horizontal:4.0),
              child: Card(
              child: ListTile(
              onTap: (){
                updateTime(index);
              },
              title: Text(locations[index].location),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/${locations[index].flag}'),
                ),
              ),
            ),
            );
          }
      ),
    );
  }
}
