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
        var randomBool = Random().nextBool();
        var secondRandomBool = Random().nextBool();
        if (randomBool && secondRandomBool) {
          gameController.endTurn();
        }
        gameController.removePiece(randomPosition.x, randomPosition.y);
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
    // var winningHistory = winningGames
    //     .firstWhere((history) => history.placements.any((historyPlacement) => historyPlacement.placementHash() == placement.placementHash()));
    // var currentPlacementIndex = winningHistory.placements.indexWhere((element) => element.placementHash() == placement.placementHash());

    Map<PlacementModel, int> winProbabilityMap = {};
    int winningGamesCount = 0;
    for (var game in winningGames) {
      try {
        if (game.placements.any(
          (historyPlacement) {
            if(game.placements.indexWhere((element) => element == historyPlacement) % 2 == 0) return false;
            return historyPlacement.placementHash() == placement.placementHash();
          },
        )) {
          var currentPlacementIndex = game.placements.indexWhere((element) => element.placementHash() == placement.placementHash());
          var placementKey = game.placements[currentPlacementIndex + 1];
          winningGamesCount++;

          bool existed = false;
          winProbabilityMap.forEach(
            (key, value) {
              if (key.placementHash() == placementKey.placementHash()) {
                winProbabilityMap[key] = winProbabilityMap[key]! + 1;
                existed = true;
              }
            },
          );
          if (!existed) {
            winProbabilityMap[placementKey] = 1;
          }
        }
      } catch (e) {
        print('BOT ERROR BOT ERROR BOT ERROR \n\n $e');
      }
    }

    PlacementModel? highestProbabilityPlacement;
    int highestProbability = 0;

    winProbabilityMap.forEach((placement, probability) {
      print('$placement - $probability');
      if (probability > highestProbability) {
        highestProbabilityPlacement = placement;
        highestProbability = probability;
      }
    });
    print('Best move in $highestProbability games out of $winningGamesCount');
    return highestProbabilityPlacement!;
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
