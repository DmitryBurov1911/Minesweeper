import 'package:flutter/material.dart';
import 'package:saper/components/bg.dart';
import 'package:saper/menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MenuScreen()),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const MainScreen(backG: "assets/images/bg.png",),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/load_smile.png",
                height: 70,),
              Image.asset("assets/images/load.png",
                height: 40,),
            ],
          )
        ],
      ),
    );
  }
}
