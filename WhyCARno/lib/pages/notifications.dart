import "package:flutter/material.dart";
import "package:whycarno/model/Book.dart";
import "package:whycarno/service/databaseSvc.dart";

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List<Book> medium=[];
  void initState(){
    super.initState();
    testDB();
  }

  void testDB(){
    DatabaseSvc().readDB();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("알림"),
      ),
      body: Center(
        child: Text("알림 페이지"),
      ),
    );
  }
}