import 'package:wooha/pages/game/models/row_model.dart';

class PlacementModel{
  final List<PlacementRowModel> rows;

  PlacementModel({required this.rows});

  String placementHash() {
    String hash = '';
    for (var row in this.rows) {
      hash += '|';
      for (var tile in row.tiles) {
        hash += tile.toString();
      }
    }
    return hash;
  }

  @override
  String toString() {
    return 'PlacementModel{rows: \n$rows}';
  }
}