import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final String? backG;

  const MainScreen({super.key, this.backG});

  @override
  Widget build(BuildContext context) {
    final theme = MediaQuery.of(context);
    return SizedBox(
      height: theme.size.height,
      width: theme.size.width,
      child: Image.asset(
        fit: BoxFit.cover, backG.toString())
    );
  }
}
