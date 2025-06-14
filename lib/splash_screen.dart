import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled12/Sing_in.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 6),()=>Navigator.push(context,CupertinoPageRoute(builder: (_)=>SingIn())));

    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network("https://pinkdogdigital.com/wp-content/uploads/2020/11/Depositphotos_373290504_L-min-1024x1024.jpg",
        width: 150,),
      ),
    );
  }
}
