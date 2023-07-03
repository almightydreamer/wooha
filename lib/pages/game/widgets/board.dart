import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wooha/pages/game/game_constants.dart';
import 'package:wooha/pages/game/models/placement_model.dart';
import 'package:wooha/pages/game/widgets/tile.dart';

import '../provider/game_provider.dart';

class Board extends ConsumerWidget {
  const Board({Key? key, required this.placement}) : super(key: key);

  final PlacementModel placement;

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        placement.rows.length,
        (row) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            row + 1,
            (piece) => Padding(
              padding: EdgeInsets.all(GameConstants.tileDimension / 4),
              child: Tile(
                  hasPiece: placement.rows[row].tiles[piece].hasPiece,
                  onTap: () {
                    ref.read(gameControllerProvider).removePiece(row, piece);
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
