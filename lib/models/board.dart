import 'package:tik_tac_toe_large/game/game_viewmodel.dart';

import 'cell.dart';
import 'figure.dart';

class Board {
  List<List<Cell>> cells;
  int height;
  int width;
  BotEntity? bot;
  Board({required this.width, required this.height, required this.cells, this.bot});

  factory Board.newBoard(int width, int height, BotEntity? bot) {
    return Board(
      bot: bot,
      width: width,
      height: height,
      cells: List.generate(height, (y) {
        return List.generate(width, (x) {
          return Cell(y: y, x: x, figure: null);
        });
      }),
    );
  }

  void setFigure(FigureTypes type, x, y) {
    if(cells[y][x].figure != null) {
      return;
    }
      cells[y][x].figure = Figure(type: type);

  }

  bool checkWin(FigureTypes type) {
    if (checkHorizontal(type)) {
      return true;
    }
    if (checkVertical(type)) {
      return true;
    }
    if (checkLBtoRTDiagonal(type)) {
      return true;
    }
    if (checkRBtoLTDiagonal(type)) {
      return true;
    }
    return false;
  }

  bool checkHorizontal(FigureTypes type) {
    for (var y = 0; y < height; y++) {
      final List<Cell> column = [];
      for (var x = 0; x < width; x++) {
        if (cells[y][x].figure?.type == type) {
          column.add(cells[y][x]);
        }
      }
      if (column.length == width) {
        return true;
      }
    }
    return false;
  }

  bool checkVertical(FigureTypes type) {
    for (var x = 0; x < width; x++) {
      final List<Cell> row = [];
      for (var y = 0; y < height; y++) {
        if (cells[y][x].figure?.type == type) {
          row.add(cells[y][x]);
        }
      }
      if (row.length == height) {
        return true;
      }
    }
    return false;
  }

  bool checkRBtoLTDiagonal (FigureTypes type) {
    List diagonal = [];
    for(int y = 0; y < height; y++) {
      if(cells[y][width - 1 - y].figure?.type == type) {
        diagonal.add(cells[y][y].figure);
      }
    }
    if(diagonal.length == height) {
      return true;
    }
    return false;
  }

  bool checkLBtoRTDiagonal (FigureTypes type) {
    List diagonal = [];
    for(int y = 0; y < height; y++) {
      if(cells[y][y].figure?.type == type) {
        diagonal.add(cells[y][y].figure);
      }
    }
    if(diagonal.length == height) {
      return true;
    }
    return false;
  }


  List<Cell> getFreeCells () {
    List<Cell> freeCells = [];

    for(var y = 0; y < height; y++) {
      for(var x = 0; x < width; x ++) {
        if(cells[y][x].figure == null) {
          freeCells.add(cells[y][x]);
        }
      }
    }

    return freeCells;
  }


}

