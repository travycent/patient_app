import 'package:flutter/material.dart';
import 'package:patient_app/constants//api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void fetch_data() async
  {
    try{
      const  token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjY2NDQ5NDg0LCJqdGkiOiIyNmRkNmZiYjU1MjQ0Yzg5OWRjYTMzNGE1N2NiYjc2MyIsInVzZXJfaWQiOjF9.ZFygUzKns1NLmaRdPndKTTG4-mzm2HzQyiSM05WlTlo";
      final response = await http.get(
        Uri.parse(api),
        // Send authorization headers to the backend.
        headers: {

          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
     // http.Response response= await http.get(Uri.parse(api));

      var data = json.decode(response.body);
      print(data);
    }
    catch(e)
    {
      print("Error is $e");
    }
  }
  @override
  void initState() {
    fetch_data();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar( ),
    );
  }
}
