// lib/screens/saved_soundtracks_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../models/soundtrack.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/track_card.dart';
import '../widgets/top_navigation_bar.dart';
import '../widgets/user_avatar.dart';

class SavedSoundtracksScreen extends StatefulWidget {
  const SavedSoundtracksScreen({super.key});

  @override
  State<SavedSoundtracksScreen> createState() => _SavedSoundtracksScreenState();
}

class _SavedSoundtracksScreenState extends State<SavedSoundtracksScreen> {
  SoundtrackWorld? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final savedTracks = context.watch<PlayerProvider>().savedTracks;
    final filteredSoundtracks = savedTracks.where((s) {
      if (_selectedFilter == null) return true;
      return s.world == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TopNavigationBar(),
              ),
            ),
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
              const UserAvatar(),
              const SizedBox(width: 16),
            ],
          ),

          // 2. Заголовок
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOUR COLLECTION / AK',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Saved soundtracks',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontSize: 36),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your worlds, ready to return to. ${savedTracks.length} soundtracks saved.',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Фильтры
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

          // 4. Отступ (ОБЁРНУТ в SliverToBoxAdapter)
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // 5. Строка с количеством
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredSoundtracks.length} SOUNDTRACKS',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const Row(
                    children: [
                      Text(
                        'Recently saved',
                        style: TextStyle(color: AppTheme.accent, fontSize: 13),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        PhosphorIconsRegular.arrowDown,
                        size: 16,
                        color: AppTheme.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 6. Отступ (ОБЁРНУТ)
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // 7. Сетка карточек
          SliverPadding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    TrackCard(track: filteredSoundtracks[index]),
                childCount: filteredSoundtracks.length,
              ),
            ),
          ),

          // 8. Плашка "All in collection"
          if (filteredSoundtracks.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(PhosphorIconsRegular.check, color: AppTheme.accent),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'All soundtracks are in your collection.',
                        style: TextStyle(color: AppTheme.accent, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 9. Нижний отступ (ОБЁРНУТ)
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, SoundtrackWorld? world) {
    final isSelected = _selectedFilter == world;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = world),
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