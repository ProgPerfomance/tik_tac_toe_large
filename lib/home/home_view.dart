import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tik_tac_toe_large/bot_dificult/bot_dificult_view.dart';
import 'package:tik_tac_toe_large/game/game_view.dart';
import 'package:tik_tac_toe_large/game/game_viewmodel.dart';
import 'package:tik_tac_toe_large/home/home_viewmodel.dart';

import '../core/widgets/page_wrapper.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      body: Wrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.width / 1.5,
                  child: PageView.builder(itemBuilder: (context,index) {
                    final item = gameMods[index];
                  return  Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff808080),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                          image: AssetImage(item.imagePath),
                        ),
                      ),
                    );
                  }, itemCount: gameMods.length,onPageChanged: (int page) {
                    viewmodel.setSelectedIndex(page);
                  },)
                ),
                SizedBox(height: 32),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ModeButton(
                      callback: () {
                        GameModeEntity mode = gameMods[viewmodel.selectedIndex];
                        final gameViewmodel = Provider.of<GameViewmodel>(context, listen: false);
                        gameViewmodel.startGame(mode.height, mode.width, null);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameView(width: mode.width, height: mode.height),
                          ),
                        );
                      },
                      title: 'С другом',
                    ),
                    SizedBox(height: 18,),
                    ModeButton(
                      callback: () {
                        GameModeEntity mode = gameMods[viewmodel.selectedIndex];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BotDificultView(gameMode: mode),
                          ),
                        );
                      },
                      title: 'С роботом',
                    ),
                    SizedBox(height: 24),
                  //  ModeButton(callback: () {}, title: 'С роботом'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ModeButton extends StatelessWidget {
  final String title;
  final void Function() callback;
  const ModeButton({super.key, required this.callback, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        height: 54,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.3),
          border: Border.all(color: Color(0xff808080), width: 3),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class GameModeEntity {
  final int width;
  final int height;
  final String imagePath;
  GameModeEntity({
    required this.width,
    required this.height,
    required this.imagePath,
  });
}




List<GameModeEntity> gameMods = [
  GameModeEntity(width: 3, height: 3, imagePath: 'assets/t3t.png'),
  GameModeEntity(width: 5, height: 5, imagePath: 'assets/t5t.png'),
  GameModeEntity(width: 7, height: 7, imagePath: 'assets/t7t.png'),
  GameModeEntity(width: 9, height: 9, imagePath: 'assets/t9t.png'),
];