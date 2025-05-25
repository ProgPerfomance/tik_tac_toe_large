import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  final Widget child;
  const Wrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/nbg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
