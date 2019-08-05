import 'package:flutter/material.dart';
import 'package:go_feed/location_picker/location_picker.dart';
import 'package:go_feed/pages/activity_feed_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  initState() {
    super.initState();
    LocationPicker.initApiKey("");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Go App",
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ActivityFeedPage(title: "Activity Feed"),
      debugShowCheckedModeBanner: false,
    );
  }
}