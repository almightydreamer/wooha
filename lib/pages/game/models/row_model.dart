import 'package:wooha/pages/game/models/tile_model.dart';

class PlacementRowModel{
  late final List<TileModel> tiles;

  PlacementRowModel({required this.tiles});

  PlacementRowModel.removePiece(PlacementRowModel rowModel,int y){
    tiles = rowModel.tiles;
    tiles[y] = TileModel(false);
  }

  @override
  String toString() {
    return 'PlacementRowModel{tiles: $tiles}';
  }
}