import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://hfzbqgzrgmrfvvmlgxfh.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmemJxZ3pyZ21yZnZ2bWxneGZoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIxODUxOTIsImV4cCI6MjA3Nzc2MTE5Mn0.vjXzKCGsUTQMWALMRbRigqCD7oh63_fljl5gbfEGuGw';

  static SupabaseClient get client => Supabase.instance.client;

  /// Inicializar Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  /// Guardar puntuación de la partida
  static Future<void> saveScore({
    required String playerName,
    required int score,
  }) async {
    try {
      print('💾 Guardando puntuación: $playerName - $score puntos');
      await client.from('scores').insert({
        'player_name': playerName,
        'score': score,
      });
      print('✅ Puntuación guardada exitosamente');
    } catch (e) {
      print('❌ Error al guardar puntuación: $e');
      rethrow;
    }
  }

  /// Obtener top 10 puntuaciones
  static Future<List<Map<String, dynamic>>> getTopScores() async {
    try {
      print('📊 Obteniendo top 10 puntuaciones...');
      final response = await client
          .from('scores')
          .select('player_name, score, created_at')
          .order('score', ascending: false)
          .order('created_at', ascending: false)
          .limit(10);

      print('✅ Top scores obtenidos: ${response.length} registros');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error al obtener puntuaciones: $e');
      return [];
    }
  }

  /// Obtener todas las puntuaciones
  static Future<List<Map<String, dynamic>>> getAllScores() async {
    try {
      final response = await client
          .from('scores')
          .select('player_name, score, created_at')
          .order('score', ascending: false)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error al obtener todas las puntuaciones: $e');
      return [];
    }
  }

  /// Verificar si una puntuación está en el top 10
  static Future<bool> isTopScore(int score) async {
    try {
      print('🔍 Verificando si $score es top score...');
      final topScores = await getTopScores();
      
      if (topScores.length < 10) {
        print('✅ Hay menos de 10 scores, cualifica automáticamente');
        return true;
      }
      
      final lowestTopScore = topScores.last['score'] as int;
      final qualifies = score >= lowestTopScore;
      print('📈 Score más bajo del top 10: $lowestTopScore');
      print('${qualifies ? "✅" : "❌"} ¿Cualifica? $qualifies');
      return qualifies;
    } catch (e) {
      print('❌ Error al verificar si es top score: $e');
      // En caso de error, asumir que sí cualifica para mostrar el diálogo
      return true;
    }
  }
}
