import 'package:flutter/material.dart';
import '../core/enums/difficulty.dart';
import '../features/home/home_screen.dart';
import '../features/new_game/new_game_screen.dart';
import '../features/game_board/game_board_screen.dart';
import '../features/history/history_screen.dart';
import '../features/ranking/ranking_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shop/shop_screen.dart';

class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String newGame = '/new-game';
  static const String gameBoard = '/game-board';
  static const String history = '/history';
  static const String ranking = '/ranking';
  static const String settings = '/settings';
  static const String shop = '/shop';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case newGame:
        return MaterialPageRoute(builder: (_) => const NewGameScreen());
      case gameBoard:
        final difficulty = routeSettings.arguments as Difficulty?;
        return MaterialPageRoute(
          builder: (_) => GameBoardScreen(difficulty: difficulty),
        );
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case ranking:
        return MaterialPageRoute(builder: (_) => const RankingScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case shop:
        return MaterialPageRoute(builder: (_) => const ShopScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
