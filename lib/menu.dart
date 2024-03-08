import 'package:flutter/material.dart';
import 'package:saper/components/bg.dart';
import 'package:saper/gameplay.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const MainScreen(backG: "assets/images/bg.png",),
          Positioned(
            right: 20,
            top: 40,
            child: Image.asset("assets/images/privacy.png", height: 40,),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/Logo.png",
                height: theme.size.height / 2,),
              Image.asset("assets/images/pionki.png",
                height: theme.size.height / 6,),
              InkWell(
                onTap: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                      const GamePlayScreen()),),
                child: Image.asset("assets/images/playnow.png",
                  height: theme.size.height / 8,),
              )
            ],
          )
        ],
      ),
    );
  }
}
