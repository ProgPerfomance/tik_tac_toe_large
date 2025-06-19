import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/ad_manager.dart';
import '../core/widgets/back_button.dart';
import '../core/widgets/board.dart';
import '../core/widgets/page_wrapper.dart';
import '../core/widgets/players_row.dart';
import '../core/widgets/repeat_button.dart';
import '../models/figure.dart';
import 'game_viewmodel.dart';

class GameView extends StatelessWidget {
  final int height;
  final int width;
  final BotEntity? bot;
  const GameView({super.key, required this.width, required this.height, this.bot});

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<GameViewmodel>(context);
    return Scaffold(
      body: Wrapper(
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    PlayerRow(bot: bot,),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Сейчас ходит:',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Image.asset(
                          viewmodel.activeFigure == FigureTypes.cross
                              ? 'assets/cross.png'
                              : 'assets/zero.png',
                          height: 42,
                          width: 42,
                        ),
                      ],
                    ),
                    SizedBox(height: 23),
                    if (viewmodel.board != null)
                      Center(child: BoardWidget(board: viewmodel.board!,bot: bot,)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BackButtonCustom(),
                        SizedBox(width: 12),
                        RepeatButton(
                          callback: () {
                            viewmodel.startGame(height, width, bot);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if(viewmodel.isWin)
              WinBanner(width: width, height: height,),
          ],
        ),
      ),
    );
  }
}


class WinBanner extends StatelessWidget {
  final int height;
  final int width;
  final BotEntity? bot;
  const WinBanner({super.key, required this.height, required this.width, this.bot});
  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<GameViewmodel>(context);
    final double _width = MediaQuery.of(context).size.width / 1.1;
    final double _height = _width * 4 / 3;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: Center(
        child: Container(
          height: _height,
          width: _width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/win1.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Align(alignment: Alignment.bottomCenter,child: RepeatButton(callback: () async {
              await AdManager().maybeShowAd(
                context: context,
                onFinish: () {},
              );
              viewmodel.startGame(height, width, bot);
            }),),
          ),
        ),
      ),
    );
  }
}
