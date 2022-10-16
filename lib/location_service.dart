import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class LocationService{
  final String key ="AIzaSyCqIAwArbvvwzfMQaco1_hxk0005Nzfjno";
  Future<String> getPlaceId(String input) async {
     final String url="https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";
     var response=await http.get(Uri.parse(url));
     var json= convert.jsonDecode(response.body);
     var placeId=json['candidates'][0]['place_id'] as String;
     return placeId;
  }
  Future<Map<String,dynamic> > getPlace(String input) async {
    final placeId=await getPlaceId(input);
    final String url="https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&&key=$key";
    var response=await http.get(Uri.parse(url));
    var json= convert.jsonDecode(response.body);
    var results=json['result'] as Map<String,dynamic>;
    //print(results);
    return results;
  }
  void _generalShowToast(String text)
  {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}