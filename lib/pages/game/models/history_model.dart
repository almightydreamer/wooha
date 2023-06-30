import 'placement_model.dart';

class HistoryModel{
  final List<PlacementModel> placements = [];

  void recordPlacement(PlacementModel placementModel){
    placements.add(placementModel);
  }

  String placementHash() {
    String hash = '';
    for (var placement in placements) {
      hash += '<';
      for (var row in placement.rows) {
        hash += '|';
        for (var tile in row.tiles) {
          hash += tile.toString();
        }
      }
      hash += '>';
    }
    return hash;
  }

  @override
  String toString() {
    return 'HistoryModel{placements: $placements}';
  }
}