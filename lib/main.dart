import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wooha/pages/game/bot/bot.dart';
import 'package:wooha/pages/game/game_constants.dart';
import 'package:wooha/pages/main_menu/main_menu_page.dart';

void main() {
  var bot = GameBot();
  bot.processTheMoves();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Wooha',
      home: MainMenu()
    );
  }
}
