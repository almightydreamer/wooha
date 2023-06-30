import 'dart:math';

import 'package:wooha/pages/game/game_constants.dart';
import 'package:wooha/pages/game/models/board_model.dart';
import 'package:wooha/pages/game/models/history_model.dart';
import 'package:wooha/pages/game/models/placement_model.dart';
import 'package:wooha/pages/game/models/tile_position.dart';
import 'package:wooha/pages/game/provider/game_provider.dart';

typedef WinningGames = List<HistoryModel>;

class GameBot {
  static WinningGames winningGames = [];

  Future<void> processTheMoves() async {
    List<TilePosition> tilePositions = getAllPossiblePositionsByRows(GameConstants.tileRows);
    int similarGeneratedGames = 0;
    int playedGames = 0;
    while (similarGeneratedGames < 10000) {
      playedGames++;
      var gameController = GameController(isSimulated: true);
      while (!gameController.gameEnded) {
        var randomPosition = tilePositions[Random().nextInt(tilePositions.length)];
        gameController.removePiece(randomPosition.x, randomPosition.y);
        var randomBool = Random().nextBool();
        var secondRandomBool = Random().nextBool();
        if (randomBool && secondRandomBool) {
          gameController.endTurn();
        }
      }
      if (gameController.isFirstPlayerTurn) {
        if (winningGames.any((element) => element.placementHash() == gameController.history.placementHash())) {
          similarGeneratedGames++;
        } else {
          print('Processing bot, similarGeneratedGames $similarGeneratedGames winningGames ${winningGames.length}');
          winningGames.add(gameController.history);
          similarGeneratedGames = 0;

        }
      }
      gameController.dispose();
    }
    print('Processed bot, ${winningGames.length} winning combinations');
    return;
  }

  PlacementModel getBestMove(PlacementModel placement) {
    var winningHistory =
        winningGames.firstWhere((history) => history.placements.any((historyPlacement) => historyPlacement.placementHash() == placement.placementHash()));
    var currentPlacementIndex = winningHistory.placements.indexWhere((element) => element.placementHash() == placement.placementHash());
    return winningHistory.placements[currentPlacementIndex + 1];
  }

  List<TilePosition> getAllPossiblePositionsByRows(int rows) {
    List<TilePosition> positions = [];
    for (int row = 0; row < rows; row++) {
      for (int tile = 0; tile < row + 1; tile++) {
        positions.add(TilePosition(row, tile));
      }
    }
    return positions;
  }
}
