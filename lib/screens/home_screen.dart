// lib/screens/home_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/track_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Переменная для отслеживания активной верхней кнопки
  int _selectedTopIndex = 0;

  @override
  Widget build(BuildContext context) {
    final allTracks = context.watch<PlayerProvider>().allTracks;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Поиск ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(PhosphorIconsRegular.magnifyingGlass,
                        color: AppTheme.textSecondary),
                    SizedBox(width: 12),
                    Text('Search scores, composers, worlds...',
                        style: TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Верхние кнопки (теперь интерактивные) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopButton(context, 'Discover', 0, PhosphorIconsRegular.compass),
                  _buildTopButton(context, 'Browse', 1, PhosphorIconsRegular.squaresFour),
                  _buildTopIcon(context, PhosphorIconsRegular.waveform, 'Listening room', 2),
                  _buildTopIcon(context, PhosphorIconsRegular.filmStrip, 'Film', 3),
                ],
              ),
              const SizedBox(height: 32),

              // --- Заголовок "Spotlight" ---
              const Text(
                'IN THE SPOTLIGHT / 001',
                style: TextStyle(
                  color: AppTheme.accent,
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Some worlds are\nheard before they\'re\nseen.',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter the sound of Arrakis. Hans Zimmer\'s otherworldly score for Dune: Part Two — vast, visceral, unforgettable.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(PhosphorIconsFill.play, color: Colors.black),
                    label: const Text(
                      'Listen to the score',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // --- Секция "Worth getting lost in" ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Worth getting lost in.',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 24)),
                  const Icon(PhosphorIconsRegular.arrowRight, size: 20),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allTracks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 150,
                        child: TrackCard(
                          track: allTracks[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),

              // --- Секция "Find your feeling" ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Find your feeling.',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 24)),
                  const Text('All moods',
                      style: TextStyle(color: AppTheme.accent, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/dune.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Neon solitude',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    Text('For the city after everyone leaves.',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton(BuildContext context, String text, int index, IconData icon) {
    final isActive = _selectedTopIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTopIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accent.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isActive ? AppTheme.accent : AppTheme.textPrimary,
                size: 18),
            const SizedBox(width: 8),
            Text(text,
                style: TextStyle(
                    color: isActive ? AppTheme.accent : AppTheme.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIcon(BuildContext context, IconData icon, String label, int index) {
    final isActive = _selectedTopIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTopIndex = index),
      child: Column(
        children: [
          Icon(icon, color: isActive ? AppTheme.accent : AppTheme.textPrimary),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: isActive ? AppTheme.accent : AppTheme.textSecondary)),
        ],
      ),
    );
  }
}