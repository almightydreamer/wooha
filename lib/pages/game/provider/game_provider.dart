import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wooha/pages/game/bot/bot.dart';
import 'package:wooha/pages/game/game_constants.dart';
import 'package:wooha/pages/game/models/board_model.dart';
import 'package:wooha/pages/game/models/history_model.dart';
import 'package:wooha/pages/game/models/placement_model.dart';
import 'package:wooha/pages/game/models/row_model.dart';
import 'package:wooha/pages/game/models/tile_model.dart';
import 'package:wooha/pages/game/models/tile_position.dart';

class GameController extends ChangeNotifier {
  BoardModel board = BoardModel(GameConstants.tileRows);
  bool isFirstPlayerTurn = true;
  bool gameEnded = false;
  List<TilePosition> currentRowTaking = [];
  HistoryModel history = HistoryModel();
  final bool isSimulated;

  GameController({this.isSimulated = false});

  void removePiece(int x, int y) {
    if (canRemovePiece(x, y)) {
      BoardModel newBoard = BoardModel.copy(board);
      newBoard.placement.rows[x] = PlacementRowModel.removePiece(newBoard.placement.rows[x], y);
      board = newBoard;
      currentRowTaking.add(TilePosition(x, y));
      gameEnded = hasWon();
      if(!isSimulated) notifyListeners();
    }
  }

  void endTurn() {
    if (currentRowTaking.isNotEmpty) {
      if(!isSimulated && isFirstPlayerTurn){
        var bot = GameBot();
        print(bot.getBestMove(board.placement));
      }
      currentRowTaking = [];
      List<PlacementRowModel> rows = board.placement.rows.map((e) {
        List<TileModel> tiles = e.tiles.map((e) => TileModel(e.hasPiece)).toList();
        return PlacementRowModel(tiles: tiles);
      }).toList();
      history.recordPlacement(PlacementModel(rows: rows));
      isFirstPlayerTurn = !isFirstPlayerTurn;
      if(!isSimulated) notifyListeners();
    }
  }

  bool canRemovePiece(int x, int y) {
    if (!board.placement.rows[x].tiles[y].hasPiece) return false;
    if (currentRowTaking.isEmpty) return true;
    if (currentRowTaking.first.x != x) return false;
    for (int tempY in currentRowTaking.map((e) => e.y)) {
      if (y + 1 == tempY || y - 1 == tempY) return true;
    }
    return false;
  }

  bool hasWon() {
    int piecesLeft = 0;
    for (var row in board.placement.rows) {
      for (var tile in row.tiles) {
        if (tile.hasPiece) {
          piecesLeft++;
        }
      }
    }
    return piecesLeft == 1;
  }
}

final gameControllerProvider = ChangeNotifierProvider.autoDispose<GameController>((ref) {
  return GameController();
});
