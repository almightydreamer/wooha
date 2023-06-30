import 'package:flutter/material.dart';
import 'package:wooha/pages/game/game_constants.dart';

class Tile extends StatelessWidget {
  const Tile({Key? key, required this.hasPiece, required this.onTap}) : super(key: key);

  final bool hasPiece;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(hasPiece){
          onTap.call();
        }
      },
      child: Container(
          height: GameConstants.tileDimension,
          width: GameConstants.tileDimension,
          color: Colors.grey,
          child: (hasPiece)
              ? Container(
                  width: GameConstants.tileDimension / 5,
                  height: GameConstants.tileDimension / 5,
                  child: const Icon(Icons.star,color: Colors.white,),
                )
              : null),
    );
  }
}
