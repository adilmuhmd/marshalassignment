import 'package:flutter/material.dart';
import 'package:marshalassignment/screens/homescreen.dart';
import 'package:marshalassignment/screens/login_page.dart';
import 'package:marshalassignment/providers/profileprovider.dart';
import 'package:marshalassignment/providers/recipeprovider.dart';
import 'package:marshalassignment/screens/recipes.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),

    ],
    child: Myapp(),
    )
  );
}


class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loginPage(),
    );
  }
}
