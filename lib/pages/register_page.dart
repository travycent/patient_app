import 'package:flutter/material.dart';
import 'package:patient_app/pages/login_page.dart';
import 'package:patient_app/pages/google_map_page.dart';
import 'package:patient_app/constants//api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
                  'Registration',
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
                  labelText: 'Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
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
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),

            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Sign Up'),
                  onPressed: () {
                    register(nameController.text.toString(),passwordController.text.toString(),emailController.text.toString(),phoneController.text.toString(),int.parse(ageController.text.toString()) , addressController.text.toString());
                  },
                )
            ),
            Row(
              children: <Widget>[
                const Text('Already have account?'),
                TextButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //sign in screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
  void register(String name,String password,String email,String phone,int age , String address) async {

    try {

        final response = await http.post(
          Uri.parse(register_api),
          body: jsonEncode({
            'email': email,
            'password': password,
            'phone' : phone,
            'name': name,
            'age': age,
            'address': address
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
            _showToast("Success : Registration Successful");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  GoogleMapPage()),
            );
          }
          else {
            var message=data['message'];
            _showToast(message);
          }
          //print(data);
        } else {
          //print('Login Failed due to the following error code : $code');
          _showToast("Login Failed due to the following error code : $code");
        }

    }catch(e){
      print(e.toString());
    }
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