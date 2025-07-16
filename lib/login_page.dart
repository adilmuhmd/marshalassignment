import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marshalassignment/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool isUser = true;
  String? errorMessage;

  Future<void>checkloginstatus()async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");


    if (token !=null){
      final profileresponse = await http.get(
        Uri.parse('https://dummyjson.com/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if(profileresponse.statusCode==200){
        final profile =jsonDecode(profileresponse.body);
        setState(() {
          isUser = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homePage(userData: profile),));
      }
    } else {
      await prefs.remove("token");
    }
    setState(() {
      isUser = false;
    });
  }

  Future<void>_login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;

    });

    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      final token = data['accessToken'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      final profileresponse = await http.get(
        Uri.parse('https://dummyjson.com/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (profileresponse.statusCode==200){
        final profile = jsonDecode(profileresponse.body);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homePage(userData: profile),));
      } else {
        setState(() {
          errorMessage = "failed to fetch user data";
        });
      }
    } else {
      setState(() {
        errorMessage = "no User Found";
      });
    }

  }


  @override
  void initState() {
    super.initState();
    checkloginstatus();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Login"),
      ),

      body: isUser
          ?  Center(child: CircularProgressIndicator())
      : Padding(padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              prefixIcon: const Icon(Icons.person),
              // filled: true,
              // fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ),

          SizedBox(height: 35,),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: const Icon(Icons.person),
              // filled: true,
              // fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ),
          SizedBox(height: 35),
          isLoading? CircularProgressIndicator() : ElevatedButton(onPressed: _login, child: Text("Login")),

          if (errorMessage != null) ...[
            const SizedBox(height: 20),
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
          ]
        ],


      ),
      ),

    );
  }
}
