// lib/main.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'providers/player_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/browse_screen.dart';
import 'screens/saved_soundtracks_screen.dart';
import 'widgets/mini_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация фонового аудио
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.frame.channel.audio',
    androidNotificationChannelName: 'FRAME Audio Playback',
    androidNotificationOngoing: true,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => PlayerProvider(),
      child: const FrameApp(),
    ),
  );
}

class FrameApp extends StatelessWidget {
  const FrameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FRAME',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const MainWrapper(),
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),                  // 0: Discover
    BrowseScreen(),                // 1: Browse
    SavedSoundtracksScreen(),      // 2: Saved soundtracks
    FavoritesScreen(),             // 3: Favorites (заглушка)
    RecentlyPlayedScreen(),        // 4: Recently played (заглушка)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(index: _currentIndex, children: _screens),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MiniPlayer(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A0A),
          border: Border(
            top: BorderSide(color: Colors.white10, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.accent,
          unselectedItemColor: AppTheme.textSecondary,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.compass), label: 'Discover'),
            BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.squaresFour), label: 'Browse'),
            BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.waveform), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.heart), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(PhosphorIconsRegular.clockCounterClockwise), label: 'Recent'),
          ],
        ),
      ),
    );
  }
}

// Заглушки
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Favorites Screen'));
}

class RecentlyPlayedScreen extends StatelessWidget {
  const RecentlyPlayedScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Recently Played Screen'));
}