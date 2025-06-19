import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tik_tac_toe_large/core/widgets/back_button.dart';
import 'package:tik_tac_toe_large/home/home_view.dart';

import '../core/ad_manager.dart';
import '../core/widgets/page_wrapper.dart';
import '../game/game_view.dart';
import '../game/game_viewmodel.dart';

class BotDificultView extends StatelessWidget {
  final GameModeEntity gameMode;
  const BotDificultView({super.key, required this.gameMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SetBotDifficulty(title: 'Легко', color: Colors.green, gameMode: gameMode, difficulty: BotDifficulty.easy,),
                SizedBox(height: 18,),
                SetBotDifficulty(title: 'Средне', color: Colors.orange, gameMode: gameMode, difficulty: BotDifficulty.medium,),
                SizedBox(height: 18,),
                SetBotDifficulty(title: 'Сложно', color: Colors.red, gameMode: gameMode, difficulty: BotDifficulty.hard,),
                SizedBox(height: 24,),
                BackButtonCustom()],
            ),
          ),
        ),
      ),
    );
  }
}

class SetBotDifficulty extends StatelessWidget {
  final gameMode;
  final String title;
  final Color color;
  final BotDifficulty difficulty;
  const SetBotDifficulty({super.key, required this.title, required this.color, required this.gameMode, required this.difficulty});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await AdManager().maybeShowAd(context: context, onFinish: () {});
        final bot = BotEntity.newBot(difficulty);

        final gameViewmodel = Provider.of<GameViewmodel>(context, listen: false);
        gameViewmodel.startGame(gameMode.height, gameMode.width, bot);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameView(width: gameMode.width, height: gameMode.height,bot: bot,),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 3),
          color: color
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
