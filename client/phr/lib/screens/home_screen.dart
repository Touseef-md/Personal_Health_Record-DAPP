import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PHR',
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'This is teh home screen',
        ),
      ),
    );
  }
}
