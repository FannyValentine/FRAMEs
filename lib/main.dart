// lib/main.dart
import 'package:flutter_application_1/screens/auth_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/player_provider.dart';
import 'providers/navigation_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/browse_screen.dart';
import 'screens/saved_soundtracks_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/recently_played_screen.dart';
import 'widgets/mini_player.dart';
import 'screens/listening_room_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nypsesphfblgsvxyigoo.supabase.co',
    publishableKey: 'sb_publishable_cOrbdP1LtILm3EiMMHGYtg_iEUHPQGY',
  );

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.frame.channel.audio',
    androidNotificationChannelName: 'FRAME Audio Playback',
    androidNotificationOngoing: true,
  );

  runApp(const FrameApp());
}

class FrameApp extends StatelessWidget {
  const FrameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( // MultiProvider здесь, оборачивает MaterialApp
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'FRAME',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final session = snapshot.data?.session;
        if (session != null) {
          return const MainWrapper();
        }
        return const AuthScreen();
      },
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final List<Widget> _screens = const [
    HomeScreen(),
    BrowseScreen(),
    SavedSoundtracksScreen(),
    ListeningRoomScreen(),
    FavoritesScreen(),
    RecentlyPlayedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>(); // 
    final safeIndex = nav.currentIndex.clamp(0, _screens.length - 1);
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            _screens[safeIndex],
            _screens[nav.currentIndex],
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MiniPlayer(),
            ),
          ],
        ),
      ),
    );
  }
}