// lib/screens/home_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/track_card.dart';
import '../widgets/top_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
              const TopNavigationBar(),
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
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 48),
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
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // --- Секция "Worth getting lost in" (без зазоров) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Worth getting lost in.',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24)),
                  const Icon(PhosphorIconsRegular.arrowRight, size: 20),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero, //   убираем горизонтальные отступы
                  itemCount: allTracks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: index == allTracks.length - 1 ? 0 : 12.0), //   зазор только между треками
                      child: SizedBox(
                        width: 150,
                        child: TrackCard(track: allTracks[index]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),

              // --- Секция "Find your feeling" (несколько карточек) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Find your feeling.',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24)),
                  const Text('All moods', style: TextStyle(color: AppTheme.accent, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMoodCard('Neon solitude', 'For the city after everyone leaves.', 'assets/images/dune.jpg'),
                    const SizedBox(width: 12),
                    _buildMoodCard('A little wonder', 'Stay curious. Let the world get bigger.', 'assets/images/spirited_away.jpg'),
                    const SizedBox(width: 12),
                    _buildMoodCard('Beyond the known', 'Big skies. Bigger possibilities.', 'assets/images/interstellar.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // --- Секция "On repeat, for a reason" (треки без зазоров) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('On repeat, for a reason.',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24)),
                  const Text('View all tracks', style: TextStyle(color: AppTheme.accent, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              // Список треков вплотную (без отступов между строками)
              Column(
                children: allTracks.take(5).map((track) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0), //   только вертикальный отступ
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            (allTracks.indexOf(track) + 1).toString().padLeft(2, '0'),
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(track.title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text('${track.artist} · ${track.albumTitle}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            context.watch<PlayerProvider>().isFavorite(track.id)
                                ? PhosphorIconsFill.heart
                                : PhosphorIconsRegular.heart,
                            color: AppTheme.accent,
                            size: 20,
                          ),
                          onPressed: () => context.read<PlayerProvider>().toggleFavorite(track.id),
                        ),
                        Text(track.formattedDuration, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodCard(String title, String subtitle, String imagePath) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}