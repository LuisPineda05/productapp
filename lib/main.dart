import 'package:flutter/material.dart';
import 'package:productapp/ui/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: ListProducts());
  }
}
