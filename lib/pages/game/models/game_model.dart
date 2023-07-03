import 'package:wooha/pages/game/models/history_model.dart';

enum VictoryBy {red, blue}



class GameModel{
  HistoryModel history;
  VictoryBy victoryBy;

  GameModel({required this.history, required this.victoryBy});
}