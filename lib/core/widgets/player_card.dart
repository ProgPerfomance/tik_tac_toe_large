import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String imagePath;
  const PlayerCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 3.3,
      width: MediaQuery.of(context).size.width / 3.3,
      decoration: BoxDecoration(
        border: Border.all(width: 2.3, color: Color(0xff808080)),
        image: DecorationImage(image: AssetImage(imagePath)),
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}
