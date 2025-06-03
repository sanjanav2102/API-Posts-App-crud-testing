import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crud_ui.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  String? userName;

  @override
  void initState() {
    super.initState();
    readUserName();
  }

  void readUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName');
    setState(() {});
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => CrudUi()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          userName ?? "No Username Found",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
