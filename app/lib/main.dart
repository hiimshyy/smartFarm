import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartfarm_app/database/mongodb.dart';
import 'package:smartfarm_app/homepage/homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider<DatabaseManager>(
      create: (_) => DatabaseManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
