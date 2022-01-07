import 'package:flutter/material.dart';
import 'package:rive_plant_focus/plant_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                const Color(0xff61B688).withOpacity(0.7),
                const Color(0xff61B688).withOpacity(0.5),
                const Color(0xff61B688).withOpacity(0.4),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: const [0.0, 0.5, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: const PlantScreen(),
      ),
    );
  }
}
