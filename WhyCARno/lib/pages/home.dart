import "package:flutter/material.dart";
import "package:whycarno/model/Media_whycarno.dart";
import "package:whycarno/service/databaseSvc.dart";

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

 
class _HomeState extends State<Home> {
  List<Media_whycarno> medium=[];
  void initState(){
    super.initState();
    testDB();
  }

  void testDB(){
    DatabaseSvc().writeDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홈"),
      ),
      body: Center(child: Text("홈 페이지")),
    );
  }
}