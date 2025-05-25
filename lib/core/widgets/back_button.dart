import 'package:flutter/material.dart';

class BackButtonCustom extends StatelessWidget {
  const BackButtonCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 64,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/back.png')),
        ),
      ),
    );
  }
}
