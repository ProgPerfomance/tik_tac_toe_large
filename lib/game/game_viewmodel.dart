import 'dart:math';
import 'package:flutter/material.dart';
import '../models/board.dart';
import '../models/figure.dart';
import '../models/cell.dart';

class GameViewmodel extends ChangeNotifier {
  bool isWin = false;
  final random = Random();
  FigureTypes activeFigure = FigureTypes.cross;
  Board? _activeBoard;

  Board? get board => _activeBoard;

  void startGame(int height, int width, BotEntity? bot) {
    isWin = false;
    activeFigure = random.nextBool() ? FigureTypes.zero : FigureTypes.cross;
    _activeBoard = Board.newBoard(width, height, bot);
    notifyListeners();

    if (activeFigure == bot?.type) {
      _scheduleBotStep(bot);
    }
  }

  bool setFigure(int y, int x, BotEntity? bot) {
    if (_activeBoard?.cells[y][x].figure != null || isWin) {
      return false;
    }

    _activeBoard?.setFigure(activeFigure, x, y);
    isWin = _activeBoard?.checkWin(activeFigure) ?? false;
    notifyListeners();

    if (!isWin) {
      _switchPlayer();
      if (activeFigure == bot?.type) {
        _scheduleBotStep(bot);
      }
    }

    return isWin;
  }

  void _switchPlayer() {
    activeFigure = activeFigure == FigureTypes.cross
        ? FigureTypes.zero
        : FigureTypes.cross;
    notifyListeners();
  }

  void _scheduleBotStep(BotEntity? bot) {
    Future.delayed(Duration(milliseconds: 100), () {
      if (!isWin && bot != null) {
        bot.step(_activeBoard!, setFigure);
      }
    });
  }
}



enum BotDifficulty { easy, medium, hard }

class BotEntity {
  final BotDifficulty difficulty;
  final FigureTypes type;

  BotEntity({required this.type, required this.difficulty});

  factory BotEntity.newBot(BotDifficulty dif) {
    return BotEntity(
      difficulty: dif,
      type: Random().nextBool() ? FigureTypes.zero : FigureTypes.cross,
    );
  }

  void step(Board board, void Function(int y, int x, BotEntity? bot) callback) {
    switch (difficulty) {
      case BotDifficulty.easy:
        _easyStep(board, callback);
        break;
      case BotDifficulty.medium:
        _mediumStep(board, callback);
        break;
      case BotDifficulty.hard:
        _hardStep(board, callback);
        break;
    }
  }

  void _easyStep(Board board, void Function(int y, int x, BotEntity? bot) callback) {
    List<Cell> cells = board.getFreeCells();
    if (cells.isEmpty) return;

    final random = Random();
    final randomCell = cells[random.nextInt(cells.length)];
    callback(randomCell.y, randomCell.x, this);
  }

  void _mediumStep(Board board, void Function(int y, int x, BotEntity? bot) callback) {
    final freeCells = board.getFreeCells();

    // Попытка победить
    for (final cell in freeCells) {
      board.setFigure(type, cell.x, cell.y);
      if (board.checkWin(type)) {
        board.cells[cell.y][cell.x].figure = null;
        callback(cell.y, cell.x, this);
        return;
      }
      board.cells[cell.y][cell.x].figure = null;
    }

    // Попытка заблокировать
    final opponent = type == FigureTypes.cross ? FigureTypes.zero : FigureTypes.cross;
    for (final cell in freeCells) {
      board.setFigure(opponent, cell.x, cell.y);
      if (board.checkWin(opponent)) {
        board.cells[cell.y][cell.x].figure = null;
        callback(cell.y, cell.x, this);
        return;
      }
      board.cells[cell.y][cell.x].figure = null;
    }

    // Иначе рандом
    _easyStep(board, callback);
  }

  void _hardStep(Board board, void Function(int y, int x, BotEntity? bot) callback) {
    if (board.width != 3 || board.height != 3) {
      _mediumStep(board, callback); // fallback
      return;
    }

    int bestScore = -9999;
    Cell? bestMove;

    for (final cell in board.getFreeCells()) {
      board.setFigure(type, cell.x, cell.y);
      int score = _minimax(board, false);
      board.cells[cell.y][cell.x].figure = null;

      if (score > bestScore) {
        bestScore = score;
        bestMove = cell;
      }
    }

    if (bestMove != null) {
      callback(bestMove.y, bestMove.x, this);
    }
  }

  int _minimax(Board board, bool isMaximizing) {
    final opponent = type == FigureTypes.cross ? FigureTypes.zero : FigureTypes.cross;

    if (board.checkWin(type)) return 1;
    if (board.checkWin(opponent)) return -1;
    if (board.getFreeCells().isEmpty) return 0;

    int bestScore = isMaximizing ? -9999 : 9999;

    for (final cell in board.getFreeCells()) {
      final figure = isMaximizing ? type : opponent;
      board.setFigure(figure, cell.x, cell.y);
      int score = _minimax(board, !isMaximizing);
      board.cells[cell.y][cell.x].figure = null;

      if (isMaximizing) {
        bestScore = max(score, bestScore);
      } else {
        bestScore = min(score, bestScore);
      }
    }

    return bestScore;
  }
}
