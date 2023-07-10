import 'dart:math';

import 'package:wooha/pages/game/game_constants.dart';
import 'package:wooha/pages/game/models/board_model.dart';
import 'package:wooha/pages/game/models/game_model.dart';
import 'package:wooha/pages/game/models/history_model.dart';
import 'package:wooha/pages/game/models/placement_model.dart';
import 'package:wooha/pages/game/models/tile_position.dart';
import 'package:wooha/pages/game/provider/game_provider.dart';


class GameBot {
  static List<GameModel> processedGames = [];

  Future<void> processTheMoves() async {
    List<TilePosition> tilePositions = getAllPossiblePositionsByRows(GameConstants.tileRows);
    int similarGeneratedGames = 0;
    int playedGames = 0;
    while (similarGeneratedGames < 10000) {
      playedGames++;
      var gameController = GameController(isSimulated: true);
      while (!gameController.gameEnded) {
        var randomPosition = tilePositions[Random().nextInt(tilePositions.length)];
        var randomConsecutiveNumbers = Random().nextInt(tilePositions.length + 4) - 1;
        var leftOrRight = Random().nextBool();
        gameController.removePiece(randomPosition.x, randomPosition.y);
        if (randomConsecutiveNumbers > 1) {
          for (int i = 0; i < randomConsecutiveNumbers; i++) {
            try {
              gameController.removePiece(randomPosition.x, (leftOrRight) ? randomPosition.y + 2 - i : randomPosition.y - 2 + i);
            } catch (_) {}
          }
        }
        gameController.endTurn();
      }
        if (processedGames.map((e) => e.history).any((element) => element.placementHash() == gameController.history.placementHash())) {
          similarGeneratedGames++;
        } else {
          print('Initializing bot, similarGeneratedGames $similarGeneratedGames processed ${processedGames.length}');
          print(gameController.history.placementHash());
          processedGames.add(GameModel(history: gameController.history, victoryBy: gameController.isFirstPlayerTurn ? VictoryBy.red : VictoryBy.blue));
          similarGeneratedGames = 0;
        }
      gameController.dispose();
    }
    print('Initialized bot, processed ${processedGames.length}');
    return;
  }

  Future<void> processMovesAdvanced()async {
    List<TilePosition> tilePositions = getAllPossiblePositionsByRows(GameConstants.tileRows);

    int availableMoves = getPossibleMovesCount(totalRows: GameConstants.tileRows, remainingPieces: getSumarial(GameConstants.tileRows), remainingRows: GameConstants.tileRows);

    while(availableMoves != 0){
      for(var i = 0; i<availableMoves; i++){
        var randomPosition = tilePositions[Random().nextInt(tilePositions.length)];
        var randomConsecutiveNumbers = Random().nextInt(tilePositions.length + 4) - 1;
        var leftOrRight = Random().nextBool();


      }
    }
  }

  PlacementModel getBestMove(PlacementModel placement) {
    // var winningHistory = winningGames
    //     .firstWhere((history) => history.placements.any((historyPlacement) => historyPlacement.placementHash() == placement.placementHash()));
    // var currentPlacementIndex = winningHistory.placements.indexWhere((element) => element.placementHash() == placement.placementHash());

    Map<PlacementModel, int> winProbabilityMap = {};
    int winningGamesCount = 0;
    for (var game in processedGames) {
      try {
        if (game.history.placements.any(
          (historyPlacement) {
            if((game.history.placements.length - 1 - game.history.placements.indexWhere((element) => element == historyPlacement)) % 2 == 0) return false;
            return historyPlacement.placementHash() == placement.placementHash();
          },
        )) {
          var currentPlacementIndex = game.history.placements.indexWhere((element) => element.placementHash() == placement.placementHash());

          var placementKey = game.history.placements[currentPlacementIndex + 1];

          bool isAFinalMove = currentPlacementIndex + 2 == game.history.placements.length;
          winningGamesCount++;
          int winRatio = isAFinalMove ? 100 : 1;
          bool existed = false;
          winProbabilityMap.forEach(
            (key, value) {
              if (key.placementHash() == placementKey.placementHash()) {
                winProbabilityMap[key] = winProbabilityMap[key]! + winRatio;
                existed = true;
              }
            },
          );
          if (!existed) {
            winProbabilityMap[placementKey] = winRatio;
          }
        }
      } catch (e, s) {
        print('BOT ERROR BOT ERROR BOT ERROR \n\n $e\n$s');
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

  int getPossibleMovesCount({required int totalRows, required int remainingPieces, required int remainingRows}){
    return getSumarial(remainingPieces)-getSumarial(totalRows-remainingRows);
  }

  int getSumarial(int number){
    return (pow(number, 2) + number)~/2;
  }
}
