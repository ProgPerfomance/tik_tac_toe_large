import 'package:flutter/material.dart';

import '../../models/figure.dart';

class FigureWidget extends StatelessWidget {
  final Figure? figure;
  const FigureWidget({super.key, required this.figure});

  @override
  Widget build(BuildContext context) {
    if (figure?.type == FigureTypes.zero) {
      return Image.asset('assets/zero.png');
    }
    if (figure?.type == FigureTypes.cross) {
      return Image.asset('assets/cross.png');
    }
    return SizedBox();
  }
}
