import 'package:flutter/material.dart';

class RepeatButton extends StatelessWidget {
  final void Function() callback;
  const RepeatButton({super.key,required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        height: 64,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/repeat.png')),
        ),
      ),
    );
  }
}
