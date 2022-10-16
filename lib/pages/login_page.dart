import 'package:flutter/material.dart';
import 'package:patient_app/pages/google_map_page.dart';
import 'package:patient_app/pages/register_page.dart';
import 'package:patient_app/constants//api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String _title = 'Patient Application ';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String login_type,String username , String password) async {

    try {
      if (login_type == "email")
      {
        final response = await http.post(
          Uri.parse(login_api),
          body: jsonEncode({
            'email': username,
            'password': password,
            'phone' : ""
          }),
          // Send authorization headers to the backend.
          headers: {

            HttpHeaders.authorizationHeader: token,
          },

        );
        var code=response.statusCode;
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body.toString());
          var  status=data['status'];
          if(status == "success"){
            _showToast("Success : Login Successful");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  GoogleMapPage()),
            );
          }
          else {
            _showToast("Invalid Username and or Password");
          }
          //print(data);
        } else {
          //print('Login Failed due to the following error code : $code');
          _showToast("Login Failed due to the following error code : $code");
        }
      }
      else if(login_type == "phone"){
        final response = await http.post(
          Uri.parse(login_api),
          body: jsonEncode({
            'phone': username,
            'password': password,
            'email' : ""
          }),
          // Send authorization headers to the backend.
          headers: {

            HttpHeaders.authorizationHeader: token,
          },

        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body.toString());
          print('Login successfully with phone');
        } else {
          print('Login Failed with phone');
        }
      }
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  '',//Sign in Text
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('Forgot Password',),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                    print(token);
                    login("email",nameController.text.toString() , passwordController.text.toString());
                  },
                )
            ),
            Row(
              children: <Widget>[
                const Text('Do not have account?'),
                TextButton(
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
  void _showToast(String text)
  {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}