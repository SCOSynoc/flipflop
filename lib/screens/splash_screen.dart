import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipflop/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
       if(user != null){
        setState(() {
          isSignedIn = true;
        });
       }else{
        setState(() {
          isSignedIn = false;
        });
       }
    });
    Timer(Duration(seconds: 3),() => Navigator.pushReplacement(context, 
     MaterialPageRoute(builder: (context) => isSignedIn? HomeScreen(): RegisterScreen())
     ));
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      width: MediaQuery.of(context).size.width,
      child: FlutterLogo(size: MediaQuery.of(context).size.width),
    );
  }
}