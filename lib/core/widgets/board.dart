import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game/game_viewmodel.dart';
import '../../models/board.dart';
import 'figure.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final BotEntity? bot;
  const BoardWidget({super.key, required this.board, required this.bot});

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<GameViewmodel>(context, listen: false);
    return SizedBox(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(board.height, (y) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(board.width, (x) {
              return GestureDetector(
                onTap: () {
                  bool result = viewmodel.setFigure(y, x, bot);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width / board.width - 12,
                  width: MediaQuery.of(context).size.width / board.width - 12,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: FigureWidget(figure: board.cells[y][x].figure),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
