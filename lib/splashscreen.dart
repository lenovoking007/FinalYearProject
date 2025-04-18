import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travelmate/onboard.dart';


class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
   
    super.initState();
    Timer(Duration(seconds: 5), ()
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => onboard()));
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset('assets/images/logo.jpg', width: 200, height: 200,)
        ),
      ),
    );
  }
}
