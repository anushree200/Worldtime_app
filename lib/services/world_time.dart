import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
class WorldTime{

  String location;
  String time='';
  String flag;//url to asset flag
  String url;//location url for api end point
  bool isDayTime=true;
  String date = '';

  WorldTime({required this.location,required this.flag,required this.url});

  Future<void> getTime() async{
    try{
      Response response = await get(Uri.parse('https://www.timeapi.io/api/Time/current/zone?timeZone=$url'),).timeout(Duration(seconds: 10));
      Map<String, dynamic> data = jsonDecode(response.body);
      //print(data);
      print("API Response: $data");
      //get properties from data

      String datetime = data['dateTime'];
      //String offset = data['utc_offset'].substring(1,3);
      //print(datetime);
      //print(offset);

      DateTime now = DateTime.parse(datetime);
      //now = now.add(Duration(hours:int.parse(offset)));
      //print(now);

      isDayTime = now.hour>6 && now.hour<18 ? true: false;
      time = DateFormat.jm().format(now);
      date = DateFormat.yMMMMd().format(now);
    }
    catch(e){
      print('caught error: $e');
      time = 'could not get time data';
    }
  }

}


