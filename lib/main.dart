import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/game_provider.dart';
import 'providers/player_provider.dart';
import 'screens/home_screen.dart';
import 'screens/game_creation_screen.dart';
import 'screens/main_game_screen.dart';
import 'screens/character_screen.dart';
import 'screens/crossroad_selection_screen.dart';
import 'screens/poi_selection_screen.dart';
import 'screens/poi_layout_screen.dart';
import 'screens/battle_screen.dart';
import 'screens/npc_screen.dart';
import 'screens/event_screen.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientation to landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Initialize database
  // await DatabaseService.instance.initDatabase();
  
  runApp(const ZombieTownApp());
}

class ZombieTownApp extends StatelessWidget {
  const ZombieTownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: MaterialApp(
        title: 'ZombieTown RPG',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red.shade800,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: _routes,
      ),
    );
  }
}

final Map<String, WidgetBuilder> _routes = {
  '/': (context) => const HomeScreen(),
  '/game-creation': (context) => const GameCreationScreen(),
  '/main-game': (context) => const MainGameScreen(),
  '/character': (context) => const CharacterScreen(),
  '/crossroad-selection': (context) => const CrossroadSelectionScreen(),
  '/poi-selection': (context) => const POISelectionScreen(),
  '/poi-layout': (context) => const POILayoutScreen(),
  '/battle': (context) => const BattleScreen(),
  '/npc': (context) => const NPCScreen(),
  '/event': (context) => const EventScreen(),
};