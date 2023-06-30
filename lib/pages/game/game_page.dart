import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wooha/pages/game/provider/game_provider.dart';
import 'package:wooha/pages/game/widgets/board.dart';
import 'package:wooha/resources/app_text_styles.dart';
import 'package:wooha/routing/app_router.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var gameController = ref.watch(gameControllerProvider);
    return WillPopScope(
      onWillPop: () {
        AppRouter.openMainMenu(context);
        return Future(() => true);
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: ref.watch(gameControllerProvider).gameEnded
              ? Colors.yellow
              : ref.watch(gameControllerProvider).isFirstPlayerTurn
                  ? Colors.red
                  : Colors.blue,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Container(
              child: Column(
                children: [
                  Board(placement: gameController.board.placement),
                  const SizedBox(
                    height: 100,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print('tapped');
                        if (gameController.gameEnded) {
                          AppRouter.openMainMenu(context);
                          ref.watch(gameControllerProvider).dispose();
                        } else {
                          ref.read(gameControllerProvider).endTurn();
                        }
                      },
                      child: Container(
                        color: Colors.black,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            gameController.gameEnded
                                ? gameController.isFirstPlayerTurn
                                    ? 'RED WON'
                                    : 'BLUE WON'
                                : 'END TURN',
                            style: AppTextStyles.bold32.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
