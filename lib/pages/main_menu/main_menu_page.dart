import 'package:flutter/material.dart';
import 'package:wooha/pages/main_menu/widgets/menu_button.dart';
import 'package:wooha/resources/app_text_styles.dart';
import 'package:wooha/routing/app_router.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Wooha',
                  style: AppTextStyles.bold32,
                ),
                const SizedBox(
                  height: 40,
                ),
                MenuButton(
                    onTap: () {
                      AppRouter.openLoadingPage(context, future: initGame(), onLoaded: () {
                        AppRouter.openGame(context);
                      });
                    },
                    title: 'Play'),
                const SizedBox(
                  height: 20,
                ),
                MenuButton(onTap: () {}, title: 'Settings'),
                const SizedBox(
                  height: 20,
                ),
                MenuButton(onTap: () {}, title: 'How to play ?'),
              ],
            )),
      ),
    );
  }

  Future<void> initGame() async {
    print('initGame');
    await Future.delayed(const Duration(seconds: 3));
    print('initGame');
  }
}
