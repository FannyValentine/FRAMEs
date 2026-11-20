// lib/screens/anime_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../models/soundtrack.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/top_navigation_bar.dart';
import '../widgets/user_avatar.dart';

class AnimeScreen extends StatefulWidget {
  const AnimeScreen({Key? key}) : super(key: key);

  @override
  State<AnimeScreen> createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen> {
  String _selectedFilter = 'All scores';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();
    final allTracks = provider.allTracks;

    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
      );
    }

    if (provider.errorMessage != null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<PlayerProvider>().loadAllData(),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    // 1. Фильтрация по миру (Anime)
    final animeTracks = allTracks
        .where((track) => track.world == SoundtrackWorld.anime)
        .toList();

    // 2. Фильтрация по кнопкам
    List<Track> filteredTracks = animeTracks;
    if (_selectedFilter == 'Essential') {
      filteredTracks = animeTracks.where((t) => provider.isFavorite(t.id)).toList();
    } else if (_selectedFilter == 'New releases') {
      final sorted = List<Track>.from(animeTracks)
        ..sort((a, b) => b.id.compareTo(a.id));
      filteredTracks = sorted.take(4).toList();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
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

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: TopNavigationBar(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WORLDS / ANIME',
                      style: TextStyle(
                        color: AppTheme.accent,
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Anime',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 48),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Extraordinary worlds. Unforgettable melodies.',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildFilterChip('All scores'),
                        const SizedBox(width: 10),
                        _buildFilterChip('Essential'),
                        const SizedBox(width: 10),
                        _buildFilterChip('New releases'),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            if (animeTracks.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () => provider.playTrack(animeTracks.first),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: animeTracks.first.imageUrl.isNotEmpty
                              ? NetworkImage(animeTracks.first.imageUrl)
                              : const AssetImage('assets/images/spirited_away.jpg') as ImageProvider,
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  animeTracks.first.title,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${animeTracks.first.albumTitle} · ${animeTracks.first.artist}',
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Positioned(
                            top: 16,
                            right: 16,
                            child: Icon(PhosphorIconsRegular.arrowRight, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Drawn into the music.',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Essential scores, extraordinary worlds.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= animeTracks.length) return const SizedBox.shrink();
                    final track = animeTracks[index];
                    return _buildPosterCard(
                      track: track,
                      onTap: () {
                        provider.clearQueue();       // используем тот же provider
                        provider.playTrack(track);
                      },
                    );
                  },
                  childCount: animeTracks.length > 4 ? 4 : animeTracks.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'On repeat in this world.',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final track = filteredTracks[index];
                  return _buildTrackListItem(context, track, index + 1, provider);
                },
                childCount: filteredTracks.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(color: isSelected ? AppTheme.accent : Colors.white24),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.accent : AppTheme.textPrimary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPosterCard({required Track track, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: track.imageUrl.isNotEmpty
                      ? NetworkImage(track.imageUrl)
                      : const AssetImage('assets/images/spirited_away.jpg') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ANIME',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            track.albumTitle,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            track.artist,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackListItem(BuildContext context, Track track, int index, PlayerProvider provider) {
    final isCurrent = provider.currentTrack?.id == track.id;
    final isFavorite = provider.isFavorite(track.id);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: isCurrent
                ? const Icon(PhosphorIconsFill.play, color: AppTheme.accent, size: 20)
                : Text(
                    index.toString().padLeft(2, '0'),
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: TextStyle(
                    color: isCurrent ? AppTheme.accent : AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${track.artist} · ${track.albumTitle}',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
              color: isFavorite ? AppTheme.accent : AppTheme.textSecondary,
              size: 20,
            ),
            onPressed: () => context.read<PlayerProvider>().toggleFavorite(track.id),
          ),
          Text(
            track.formattedDuration,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}