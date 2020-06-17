import 'package:ChineseAppRemover/body.dart';
import 'package:ChineseAppRemover/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0.0,
        title: Center(
          child: Text(
            'KILL THE DRAGON ⚔',
            style: head1,
          ),
        ),
        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Hero(
              tag: 'main',
              child: Image.asset(
                'assets/dragon.png',
                width: width * 0.8,
              )),
          Body(),
          GestureDetector(
            onTap: () {
              setState(() {
                reget = true;
              });
            },
            child: Container(
              child: Center(
                child: Text('SCAN AGAIN', style: buttonText),
              ),
              color: secondary,
              margin: EdgeInsets.only(top: 10),
              height: 80.0,
              width: double.infinity,
            ),
          )
        ],
      ),
    );
  }
}
