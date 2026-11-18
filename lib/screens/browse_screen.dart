// lib/screens/browse_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../models/soundtrack.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/soundtrack_card.dart'; // Переиспользуем карточку

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  // Текущий выбранный мир (null = "All worlds")
  SoundtrackWorld? _selectedWorld;

  @override
  Widget build(BuildContext context) {
    final browseTracks = context.watch<PlayerProvider>().browseSoundtracks;
    final filteredTracks = browseTracks.where((s) {
      if (_selectedWorld == null) return true;
      return s.world == _selectedWorld;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. AppBar
            SliverAppBar(
              backgroundColor: AppTheme.background,
              elevation: 0,
              pinned: true,
              title: RichText(
                text: const TextSpan(
                  text: 'FRAME ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: AppTheme.textPrimary,
                  ),
                  children: [
                    TextSpan(text: '/', style: TextStyle(color: AppTheme.accent)),
                  ],
                ),
              ),
              actions: [
                const SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: AppTheme.accent.withOpacity(0.2),
                  child: const Text(
                    'AK',
                    style: TextStyle(color: AppTheme.accent, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),

            // 2. Заголовок "Every shade of sound."
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BROWSE / ALL GENRES',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Every shade of\nsound.',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 42),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'From a single piano to a hundred-piece orchestra. Find your way in.',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Фильтры (All worlds / Film / Anime / Animation)
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildFilterChip('All worlds', null),
                    const SizedBox(width: 8),
                    _buildFilterChip('Film', SoundtrackWorld.film),
                    const SizedBox(width: 8),
                    _buildFilterChip('Anime', SoundtrackWorld.anime),
                    const SizedBox(width: 8),
                    _buildFilterChip('Animation', SoundtrackWorld.animation),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 4. Сетка с карточками
            SliverPadding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
              sliver: filteredTracks.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'Nothing here yet.\nTry a different filter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.65,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            SoundtrackCard(soundtrack: filteredTracks[index]),
                        childCount: filteredTracks.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, SoundtrackWorld? world) {
    final isSelected = _selectedWorld == world;
    return GestureDetector(
      onTap: () => setState(() => _selectedWorld = world),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppTheme.accent : Colors.white24,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.accent : AppTheme.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}