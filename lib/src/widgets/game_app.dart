import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../brick_breaker.dart';
import '../config.dart';
import '../services/supabase_service.dart';
import 'leaderboard_screen.dart';
import 'overlay_screen.dart';
import 'save_score_dialog.dart';
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
    _initSupabase();
  }

  Future<void> _initSupabase() async {
    try {
      await SupabaseService.initialize();
    } catch (e) {
      print('Error inicializando Supabase: $e');
    }
  }

  Future<void> _checkAndSaveScore(int score) async {
    if (score == 0) return;

    final isTopScore = await SupabaseService.isTopScore(score);
    if (isTopScore && mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SaveScoreDialog(score: score),
      );
    }
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
