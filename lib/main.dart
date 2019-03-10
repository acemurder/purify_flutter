import 'package:flutter/material.dart';
import 'package:purify_flutter/config.dart';
import 'package:purify_flutter/search.dart';

void main() {
  runApp(new MaterialApp(
    home: PurifyApp(),
  ));
}

class PurifyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: colorPrimary, title: Text("Purify Flutter")),
      body: new Column(
        children: <Widget>[
          new SearchWidget(),
        ],
      ),
    );
  }
}
