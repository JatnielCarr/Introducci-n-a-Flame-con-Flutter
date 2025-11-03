import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../brick_breaker.dart';
import '../config.dart';
import '../services/audio_service.dart';
import '../services/supabase_service.dart';
import 'leaderboard_screen.dart';
import 'overlay_screen.dart';
import 'score_card.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final BrickBreaker game;

  @override
  void initState() {
    super.initState();
    game = BrickBreaker();
    _initServices();
  }

  Future<void> _initServices() async {
    await _initSupabase();
    await _initAudio();
  }

  Future<void> _initSupabase() async {
    try {
      print('🔄 Inicializando Supabase...');
      await SupabaseService.initialize();
      print('✅ Supabase inicializado correctamente');
    } catch (e) {
      print('❌ Error inicializando Supabase: $e');
    }
  }

  Future<void> _initAudio() async {
    try {
      await AudioService.initialize();
      await AudioService.playBackgroundMusic();
    } catch (e) {
      print('❌ Error inicializando audio: $e');
    }
  }

  Future<void> _checkAndSaveScore(int score) async {
    print('🎯 Guardando puntuación: $score');
    
    if (!mounted) return;

    try {
      // Intentar guardar en Supabase
      print('💾 Intentando guardar en Supabase...');
      await SupabaseService.saveScore(
        playerName: 'Jugador',
        score: score,
      );
      print('✅ Puntuación guardada en Supabase');
      
      // Mostrar confirmación
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Puntuación guardada: $score puntos!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Error guardando score: $e');
      
      // Si hay error de conexión, informar al usuario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sin conexión a internet. Puntuación: $score'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _onGameOver() {
    AudioService.playGameOver();
  }

  @override
  void dispose() {
    AudioService.dispose();
    super.dispose();
  }

  void _showLeaderboard() {
    showDialog(
      context: context,
      builder: (context) => const LeaderboardScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xff184e77),
          displayColor: const Color(0xff184e77),
        ),
      ),
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffa9d6e5), Color(0xfff2e8cf)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ScoreCard(score: game.score),
                            IconButton(
                              icon: const Icon(Icons.leaderboard, size: 32),
                              onPressed: _showLeaderboard,
                              tooltip: 'Leaderboard (L)',
                            ),
                          ],
                        ),
                        Expanded(
                          child: FittedBox(
                            child: SizedBox(
                              width: gameWidth,
                              height: gameHeight,
                              child: GameWidget(
                                game: game,
                                overlayBuilderMap: {
                                  PlayState.welcome.name: (context, game) =>
                                      const OverlayScreen(
                                        title: 'TAP TO PLAY',
                                        subtitle: 'Use arrow keys or swipe',
                                      ),
                                  PlayState.gameOver.name: (context, game) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _onGameOver();
                                      _checkAndSaveScore((game as BrickBreaker).score.value);
                                    });
                                    return const OverlayScreen(
                                      title: 'G A M E   O V E R',
                                      subtitle: 'Tap to Play Again',
                                    );
                                  },
                                  PlayState.won.name: (context, game) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _checkAndSaveScore((game as BrickBreaker).score.value);
                                    });
                                    return const OverlayScreen(
                                      title: 'Y O U   W O N ! ! !',
                                      subtitle: 'Tap to Play Again',
                                    );
                                  },
                                },
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
            ValueListenableBuilder<bool>(
              valueListenable: game.showLeaderboard,
              builder: (context, show, child) {
                return show ? const LeaderboardScreen() : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
