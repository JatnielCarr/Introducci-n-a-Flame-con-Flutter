# Brick Breaker - Integración con Supabase

## 🎮 Juego Completo con Puntuaciones en la Nube

Este proyecto es un juego de Brick Breaker construido con Flutter y Flame, con integración de Supabase para almacenar puntuaciones en línea.

## 📋 SQL para Supabase

Ejecuta este código SQL en tu dashboard de Supabase (SQL Editor):

```sql
-- Crear tabla de puntuaciones
CREATE TABLE scores (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  player_name TEXT NOT NULL,
  score INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Crear índice para ordenar por puntuación
CREATE INDEX idx_scores_score ON scores(score DESC);

-- Habilitar RLS (Row Level Security)
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;

-- Política para permitir lectura a todos
CREATE POLICY "Allow public read access" ON scores
  FOR SELECT
  USING (true);

-- Política para permitir inserción a todos
CREATE POLICY "Allow public insert access" ON scores
  FOR INSERT
  WITH CHECK (true);

-- Opcional: Crear una vista para el top 10
CREATE OR REPLACE VIEW top_scores AS
SELECT player_name, score, created_at
FROM scores
ORDER BY score DESC, created_at ASC
LIMIT 10;
```

## 🚀 Características

### Sistema de Puntuación
- ✅ Puntuación en tiempo real mientras juegas
- ✅ Cada ladrillo destruido suma 1 punto
- ✅ Puntuación máxima: 50 puntos (50 ladrillos)

### Integración con Supabase
- ✅ Guardar puntuaciones en la nube
- ✅ Verificación automática si tu puntuación está en el Top 10
- ✅ Diálogo para ingresar tu nombre al lograr un high score
- ✅ Tabla de clasificación (Leaderboard) con animaciones

### Controles
- **Teclado**: Flechas izquierda/derecha para mover el bate
- **Mouse/Táctil**: Arrastra el bate con el dedo o mouse
- **Iniciar juego**: Toca la pantalla, Espacio o Enter
- **Ver Leaderboard**: Presiona `L` o haz clic en el icono 📊

## 🎯 Flujo del Juego

1. **Pantalla de Bienvenida**: "TAP TO PLAY"
2. **Juego**: Rompe los 50 ladrillos
3. **Fin del Juego**: 
   - Si es Top 10 → Diálogo para guardar nombre
   - Ver tabla de clasificación
   - Jugar de nuevo

## 📊 Leaderboard

- Muestra las mejores 10 puntuaciones
- Medallas:
  - 🥇 Oro: Primer lugar
  - 🥈 Plata: Segundo lugar
  - 🥉 Bronce: Tercer lugar
- Animaciones al aparecer
- Accesible con tecla `L` o botón en pantalla

## 🔐 Configuración de Supabase

La configuración ya está en `lib/src/services/supabase_service.dart`:

```dart
static const String supabaseUrl = 'https://hfzbqgzrgmrfvvmlgxfh.supabase.co';
static const String supabaseAnonKey = 'tu-anon-key';
```

## 📁 Estructura de Archivos

```
lib/
├── main.dart
└── src/
    ├── brick_breaker.dart           # Motor del juego
    ├── config.dart                  # Configuración
    ├── components/
    │   ├── ball.dart
    │   ├── bat.dart
    │   ├── brick.dart
    │   ├── play_area.dart
    │   └── components.dart
    ├── services/
    │   └── supabase_service.dart    # 🆕 Servicio de Supabase
    └── widgets/
        ├── game_app.dart
        ├── score_card.dart
        ├── overlay_screen.dart
        ├── leaderboard_screen.dart  # 🆕 Tabla de clasificación
        └── save_score_dialog.dart   # 🆕 Diálogo para guardar
```

## 🛠️ Instalación

1. Clona el repositorio
2. Ejecuta: `flutter pub get`
3. Configura Supabase con el SQL proporcionado
4. Ejecuta: `flutter run`

## 🎨 Tecnologías Usadas

- **Flutter**: Framework de UI
- **Flame**: Motor de juegos 2D
- **Supabase**: Backend como servicio (BaaS)
- **Google Fonts**: Fuente estilo retro
- **Flutter Animate**: Animaciones suaves

## 📝 Notas

- La puntuación se guarda automáticamente si está en el Top 10
- Puedes saltar el guardado de nombre
- La tabla de puntuaciones se actualiza en tiempo real
- RLS (Row Level Security) está habilitado para seguridad

## 🎮 ¡Disfruta el Juego!

¡Rompe todos los ladrillos y conviértete en el campeón del Leaderboard! 🏆
