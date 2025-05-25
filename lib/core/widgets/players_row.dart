import 'package:flutter/material.dart';
import 'package:tik_tac_toe_large/core/widgets/player_card.dart';
import 'package:tik_tac_toe_large/game/game_viewmodel.dart';

class PlayerRow extends StatelessWidget {
  final BotEntity? bot;
  const PlayerRow({super.key, this.bot});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayerCard(imagePath: 'assets/menino.png'),
        SizedBox(width: 24),
        Row(
          children: [
            Text(
              'VS',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(width: 24),
        PlayerCard(imagePath: bot != null? 'assets/bot.png' : 'assets/cat.png'),
      ],
    );
  }
}

