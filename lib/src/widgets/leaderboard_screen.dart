import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/supabase_service.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.15),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        margin: const EdgeInsets.all(32),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TOP SCORES',
                style: Theme.of(context).textTheme.headlineMedium,
              ).animate().slideY(duration: 500.ms, begin: -2, end: 0),
              const SizedBox(height: 16),
              SizedBox(
                height: 400,
                width: 300,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: SupabaseService.getTopScores(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final scores = snapshot.data ?? [];

                    if (scores.isEmpty) {
                      return const Center(
                        child: Text('No scores yet!\nBe the first!'),
                      );
                    }

                    return ListView.builder(
                      itemCount: scores.length,
                      itemBuilder: (context, index) {
                        final score = scores[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getMedalColor(index),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            score['player_name'] ?? 'Anonymous',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          trailing: Text(
                            '${score['score']}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ).animate().fadeIn(
                              delay: (100 * index).ms,
                              duration: 300.ms,
                            );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CLOSE'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMedalColor(int position) {
    switch (position) {
      case 0:
        return Colors.amber; // Oro
      case 1:
        return Colors.grey.shade400; // Plata
      case 2:
        return Colors.brown.shade300; // Bronce
      default:
        return Colors.blue;
    }
  }
}
