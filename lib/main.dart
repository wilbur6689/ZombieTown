import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'providers/game_provider.dart';
import 'providers/player_provider.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/character_screen.dart';
import 'screens/poi_screen.dart';
import 'screens/battle_screen.dart';
import 'screens/npc_screen.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseService.instance.initDatabase();
  
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
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'ZombieTown RPG',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.red.shade800,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              fontFamily: 'ZombieTown',
            ),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GameScreen(),
    ),
    GoRoute(
      path: '/character',
      builder: (context, state) => const CharacterScreen(),
    ),
    GoRoute(
      path: '/poi/:type',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        return POIScreen(poiType: type);
      },
    ),
    GoRoute(
      path: '/battle',
      builder: (context, state) => const BattleScreen(),
    ),
    GoRoute(
      path: '/npc/:npcId',
      builder: (context, state) {
        final npcId = state.pathParameters['npcId']!;
        return NPCScreen(npcId: npcId);
      },
    ),
  ],
);