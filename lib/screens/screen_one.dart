import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen_two.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  TextEditingController userName = TextEditingController();

  void storeUserData(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', username);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ScreenTwo()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: userName,
                decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "Enter your name",
                ),
              ),
              ElevatedButton(
                onPressed: () => storeUserData(userName.text),
                child: Text("Save & Go to Next Screen"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
