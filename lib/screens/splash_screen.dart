import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme(data: data, child: child),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Text("Loading..."),
      ),
    );
  }
}
