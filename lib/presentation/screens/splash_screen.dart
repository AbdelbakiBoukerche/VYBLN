import 'dart:ui';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 88.0),
              child: Image(
                image: AssetImage("assets/images/vybln.png"),
                height: MediaQuery.of(context).size.height * 0.3,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 24.0),
              child: Text(
                "By Abdelbaki Boukerche",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black.withOpacity(0.45),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
