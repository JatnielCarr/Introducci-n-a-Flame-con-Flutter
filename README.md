# 🎮 Brick Breaker Game

Un juego clásico de Brick Breaker (Breakout) construido con **Flutter** y **Flame**, con integración de **Supabase** para almacenar puntuaciones en línea.

![Flutter](https://img.shields.io/badge/Flutter-3.8.0-02569B?logo=flutter)
![Flame](https://img.shields.io/badge/Flame-1.28.1-orange)
![Supabase](https://img.shields.io/badge/Supabase-2.8.0-3ECF8E?logo=supabase)

## 📋 Descripción

Re-implementación del clásico juego Breakout de Steve Wozniak, con gráficos modernos y sistema de puntuación en línea. Rompe los 50 ladrillos coloridos, mantén la pelota en juego con el bate y compite por el primer lugar en la tabla de clasificación global.

## ✨ Características

### 🎯 Mecánicas del Juego
- ✅ 50 ladrillos en 10 colores diferentes
- ✅ Física realista de rebote de pelota
- ✅ Dificultad progresiva (la pelota acelera con cada ladrillo)
- ✅ Control fluido del bate (teclado y mouse/táctil)
- ✅ Detección precisa de colisiones
- ✅ Efectos visuales y animaciones

### 🏆 Sistema de Puntuación
- ✅ Puntuación en tiempo real
- ✅ Cada ladrillo = 1 punto (máximo 50)
- ✅ Guardado automático de high scores
- ✅ Tabla de clasificación Top 10
- ✅ Verificación automática de récords

### 🎨 Interfaz de Usuario
- ✅ Pantalla de bienvenida animada
- ✅ Tarjeta de puntuación visible
- ✅ Superposiciones con animaciones suaves
- ✅ Leaderboard con medallas (🥇🥈🥉)
- ✅ Fuente retro estilo arcade
- ✅ Diseño responsivo multi-plataforma

### ☁️ Integración con Supabase
- ✅ Backend en la nube
- ✅ Base de datos PostgreSQL
- ✅ Almacenamiento inteligente de puntuaciones
- ✅ Solo guarda si superas tu mejor score
- ✅ Consultas en tiempo real
- ✅ Row Level Security (RLS)
- ✅ Top 5 mejores puntuaciones
- ✅ Ordenamiento justo (más reciente gana en empate)

## 🎮 Controles

| Acción | Controles |
|--------|-----------|
| Mover bate izquierda | ⬅️ Flecha izquierda |
| Mover bate derecha | ➡️ Flecha derecha |
| Arrastrar bate | 🖱️ Mouse / 👆 Táctil |
| Iniciar/Reiniciar juego | 👆 Toque / Espacio / Enter |
| Ver Leaderboard | `L` / 📊 Botón |

## 🚀 Instalación

### Requisitos Previos

- Flutter SDK 3.8.0 o superior
- Dart SDK 3.8.0 o superior
- Cuenta de Supabase (gratis)
- IDE: VS Code, Android Studio o IntelliJ

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone <tu-repositorio>
cd flutter_application_1
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Supabase**

   a. Crea un proyecto en [Supabase](https://supabase.com)
   
   b. En el SQL Editor, ejecuta:
   ```sql
   -- Crear tabla de puntuaciones
   CREATE TABLE scores (
     id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
     player_name TEXT NOT NULL,
     score INTEGER NOT NULL,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
   );

   -- Crear índice
   CREATE INDEX idx_scores_score ON scores(score DESC);

   -- Habilitar RLS
   ALTER TABLE scores ENABLE ROW LEVEL SECURITY;

   -- Políticas de acceso público
   CREATE POLICY "Allow public read access" ON scores
     FOR SELECT USING (true);

   CREATE POLICY "Allow public insert access" ON scores
     FOR INSERT WITH CHECK (true);
   ```

   c. Copia tu Project URL y API Key (anon/public)
   
   d. Actualiza `lib/src/services/supabase_service.dart`:
   ```dart
   static const String supabaseUrl = 'TU_PROJECT_URL';
   static const String supabaseAnonKey = 'TU_ANON_KEY';
   ```

   **Ubicación de credenciales en Supabase:**
   - Ve a: Project Settings → API
   - **Project URL**: En la sección "Configuration"
   - **anon/public key**: En la sección "Project API keys"

4. **Ejecutar la aplicación**
```bash
flutter run
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada
└── src/
    ├── brick_breaker.dart             # Motor del juego Flame
    ├── config.dart                    # Configuración global
    ├── components/                    # Componentes del juego
    │   ├── ball.dart                  # Pelota
    │   ├── bat.dart                   # Bate
    │   ├── brick.dart                 # Ladrillos
    │   ├── play_area.dart             # Área de juego
    │   └── components.dart            # Exportaciones
    ├── services/                      # 🆕 Servicios
    │   └── supabase_service.dart      # Cliente Supabase
    └── widgets/                       # Widgets Flutter
        ├── game_app.dart              # App principal
        ├── score_card.dart            # Tarjeta de puntuación
        ├── overlay_screen.dart        # Pantallas de overlay
        ├── leaderboard_screen.dart    # 🆕 Tabla de clasificación
        └── save_score_dialog.dart     # 🆕 Diálogo de guardado
```

## 🛠️ Tecnologías Usadas

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| [Flutter](https://flutter.dev) | 3.8.0 | Framework de UI multiplataforma |
| [Flame](https://flame-engine.org) | 1.28.1 | Motor de juegos 2D |
| [Supabase Flutter](https://supabase.com/docs/reference/dart) | 2.8.0 | Backend como servicio (BaaS) |
| [Google Fonts](https://pub.dev/packages/google_fonts) | 6.2.1 | Fuente Press Start 2P (retro) |
| [Flutter Animate](https://pub.dev/packages/flutter_animate) | 4.5.2 | Animaciones declarativas |

## 🎯 Cómo Jugar

1. **Inicio**: Toca la pantalla o presiona Espacio/Enter
2. **Objetivo**: Rompe todos los 50 ladrillos
3. **Controles**: Usa las flechas o arrastra el bate para golpear la pelota
4. **Puntuación**: Cada ladrillo roto suma 1 punto
5. **Victoria**: Destruye todos los ladrillos
6. **Derrota**: Si la pelota cae por debajo del bate
7. **High Score**: Si logras Top 10, ingresa tu nombre
8. **Leaderboard**: Presiona `L` para ver la tabla de clasificación

## 🏆 Sistema de Puntuación

- Puntuación máxima: **50 puntos**
- Se guarda automáticamente si está en el **Top 10**
- Ordenamiento: Por puntuación (DESC) y fecha (ASC)
- Medallas:
  - 🥇 **Oro**: 1er lugar
  - 🥈 **Plata**: 2do lugar
  - 🥉 **Bronce**: 3er lugar

## 🔐 Seguridad

- ✅ Row Level Security (RLS) habilitado en Supabase
- ✅ Solo operaciones de lectura e inserción públicas
- ✅ Las API keys se pueden exponer de forma segura (solo con RLS)
- ⚠️ **Importante**: En producción, considera usar variables de entorno

## � Personalización de Iconos y Splash Screen

### Iconos de la Aplicación

El proyecto incluye iconos personalizados para todas las plataformas usando `flutter_launcher_icons`.

**Configuración en `pubspec.yaml`:**
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/icon.png"
  remove_alpha_ios: true
  web:
    generate: true
    image_path: "assets/images/icon.png"
  windows:
    generate: true
    image_path: "assets/images/icon.png"
  macos:
    generate: true
    image_path: "assets/images/icon.png"
```

**Para actualizar los iconos:**
1. Reemplaza `assets/images/icon.png` con tu imagen (mínimo 1024x1024px)
2. Ejecuta: `dart run flutter_launcher_icons`

### Splash Screen

Pantalla de carga personalizada con color de fondo `#f2e8cf` (beige) usando `flutter_native_splash`.

**Configuración en `pubspec.yaml`:**
```yaml
flutter_native_splash:
  color: "#f2e8cf"
  image: assets/images/icon.png
  android_12:
    color: "#f2e8cf"
    image: assets/images/icon.png
  web: true
  android: true
  ios: true
```

**Para actualizar el splash:**
1. Modifica el color o imagen en `pubspec.yaml`
2. Ejecuta: `dart run flutter_native_splash:create`

**Plataformas generadas:**
- ✅ Android (incluye soporte Android 12+)
- ✅ iOS (launch images)
- ✅ Web (con CSS personalizado)

## �🌍 Plataformas Soportadas

- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web
- ✅ Android
- ✅ iOS

## 📝 Licencia

Este proyecto está bajo la licencia MIT.

## 👨‍💻 Autor

Creado como implementación del codelab de Flutter/Flame.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📚 Recursos Adicionales

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de Flame](https://docs.flame-engine.org/)
- [Documentación de Supabase](https://supabase.com/docs)
- [Codelab Original](https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker)
- [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons)
- [Flutter Native Splash](https://pub.dev/packages/flutter_native_splash)

## ⚙️ Comandos Útiles

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Ejecutar en modo release
flutter run --release

# Generar iconos
dart run flutter_launcher_icons

# Generar splash screens
dart run flutter_native_splash:create

# Limpiar build
flutter clean

# Verificar código
flutter analyze

# Formatear código
dart format .
```

## 🐛 Reportar Bugs

Si encuentras un bug, por favor abre un issue con:
- Descripción del problema
- Pasos para reproducirlo
- Comportamiento esperado vs actual
- Screenshots (si aplica)
- Información del dispositivo/plataforma

## 🎉 ¡Disfruta el Juego!

¡Rompe todos los ladrillos y conviértete en el campeón del Leaderboard! 🏆

---

**Nota**: Este es un proyecto educativo basado en el codelab oficial de Flutter/Flame con mejoras adicionales de integración con Supabase.

