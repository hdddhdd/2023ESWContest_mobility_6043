import 'package:flutter/material.dart';
import 'package:whycarno/service/databaseSvc.dart';
import 'bottom_nav.dart';
import 'pages/home.dart';
import 'pages/records.dart';
import 'pages/notifications.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
 
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //   ////
  // void initState(){
  //   super.initState();
  //   testDB();
  // }

  // void testDB(){
  //   DatabaseSvc().writeDB();
  // }
  ///

  int _currentIndex = 0;

  final List<Widget> _pages = [Home(), Records(), Notifications()];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // App Bar를 제거합니다.
      body: _pages[_currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
