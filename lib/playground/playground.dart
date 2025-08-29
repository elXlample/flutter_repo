import 'package:flutter/material.dart';
import 'package:playground/playground/http.dart';

class Playground extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlaygroundState();
  }
}

class PlaygroundState extends State<Playground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/http');
                },
                child: Text('http_methods'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/async_stream');
              },
              child: Text('async stream'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/bloc');
              },
              child: Text('bloc'),
            ),
          ],
        ),
      ),
    );
  }
}
