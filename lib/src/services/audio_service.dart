import 'package:flame_audio/flame_audio.dart';

class AudioService {
  static bool _initialized = false;
  static bool _isMusicPlaying = false;

  /// Inicializar el servicio de audio
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      print('🎵 Inicializando servicio de audio...');
      FlameAudio.bgm.initialize();
      await FlameAudio.audioCache.loadAll([
        'background_music.mp3',
        'game_over.mp3',
      ]);
      _initialized = true;
      print('✅ Audio inicializado correctamente');
    } catch (e) {
      print('❌ Error inicializando audio: $e');
    }
  }

  /// Reproducir música de fondo (loop infinito)
  static Future<void> playBackgroundMusic() async {
    if (!_initialized || _isMusicPlaying) return;
    
    try {
      await FlameAudio.bgm.play('background_music.mp3', volume: 0.5);
      _isMusicPlaying = true;
      print('🎵 Música de fondo reproduciendo');
    } catch (e) {
      print('❌ Error reproduciendo música: $e');
    }
  }

  /// Detener música de fondo
  static void stopBackgroundMusic() {
    if (!_initialized || !_isMusicPlaying) return;
    
    FlameAudio.bgm.stop();
    _isMusicPlaying = false;
    print('⏹️ Música de fondo detenida');
  }

  /// Pausar música de fondo
  static void pauseBackgroundMusic() {
    if (!_initialized || !_isMusicPlaying) return;
    
    FlameAudio.bgm.pause();
    print('⏸️ Música de fondo pausada');
  }

  /// Reanudar música de fondo
  static void resumeBackgroundMusic() {
    if (!_initialized) return;
    
    FlameAudio.bgm.resume();
    print('▶️ Música de fondo reanudada');
  }

  /// Reproducir sonido de game over
  static Future<void> playGameOver() async {
    if (!_initialized) return;
    
    try {
      await FlameAudio.play('game_over.mp3', volume: 0.7);
      print('💀 Sonido de game over reproducido');
    } catch (e) {
      print('❌ Error reproduciendo game over: $e');
    }
  }

  /// Ajustar volumen de la música
  static void setMusicVolume(double volume) {
    if (!_initialized) return;
    FlameAudio.bgm.audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Limpiar recursos de audio
  static void dispose() {
    if (!_initialized) return;
    
    FlameAudio.bgm.dispose();
    _initialized = false;
    _isMusicPlaying = false;
    print('🗑️ Recursos de audio liberados');
  }
}
