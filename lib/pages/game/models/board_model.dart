import 'package:wooha/pages/game/models/placement_model.dart';
import 'package:wooha/pages/game/models/row_model.dart';

class BoardModel {
  late PlacementModel placement;

  BoardModel(int rows) {
    placement = PlacementModel(
      rows: List.generate(
        rows,
        (index) => PlacementRowModel(
          tiles: List.generate(index + 1, (index) => true),
        ),
      ),
    );
  }
}
