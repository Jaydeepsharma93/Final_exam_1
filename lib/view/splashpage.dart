import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 4),() {
      Navigator.pushReplacementNamed(context, '/home');
    },);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 320,
          width: 300,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
           boxShadow: [
             BoxShadow(
               blurRadius: 20,
               spreadRadius: 2,
               color: Colors.black12
             )
           ]
          ),
          child: Container(
            height: 320,
            width: 300,
            child: Image.asset('assets/img/applogo.png',fit: BoxFit.cover,),
          ),
        ),
      ),
    );
  }
}
