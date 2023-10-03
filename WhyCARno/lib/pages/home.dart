import "dart:js_util";

import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:whycarno/model/Book.dart";
import "package:whycarno/model/Whycarno.dart";
import "package:whycarno/service/databaseSvc.dart";
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _FetchDataState();
}

class _FetchDataState extends State<Home> {
  List<Whycarno> medium = [];
  void initState() {
    super.initState();
    testDB();
  }

  void testDB() {
    DatabaseSvc().writeDB();
  }

  Query dbref = FirebaseDatabase.instance.ref().child('mydata/2023-10-02/');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('mydata/');

  Widget listItem({required Map mydata}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 110,
      color: Colors.amberAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mydata['longitude'],
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            mydata['latitude'],
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            mydata['video_Url'],
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홈"),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: dbref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map mydata = snapshot.value as Map;
            mydata['key'] = snapshot.key;

            return listItem(mydata: mydata);
          },
        ),
      ),
    );
  }
}
