import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/soundtrack.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/track_card.dart';
import '../widgets/top_navigation_bar.dart';
import '../widgets/user_avatar.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}
List<String> _getAllGenres(PlayerProvider provider) {
  // Собираем уникальные жанры из всех загруженных треков
  final genres = provider.allTracks
      .map((track) => track.genre)
      .whereType<String>() // отбрасываем null
      .toSet()             // убираем дубликаты
      .toList();

  // Если по какой-то причине список пуст (например, треки ещё не загрузились),
  // возвращаем жанры по умолчанию, чтобы UI не сломался.
  if (genres.isEmpty) {
    return [
      'Horus & Orchestra',
      'Symphonic & Score',
      'Ambient & Atmospheric',
      'Electronic & Synth',
      'Jazz & Blues',
      'Piano & Minimal',
      'Adventure & Epic',
      'Folk & Acoustic',
    ];
  }

  return genres;
}
class _BrowseScreenState extends State<BrowseScreen> {
  SoundtrackWorld? _selectedWorld;
  final TextEditingController _searchController = TextEditingController();
  bool _easterEggTriggered = false;
  List<String> _shuffledGenres = [];

  @override
  void initState() {
  super.initState();
  }

  //   Логика пасхалки
  void _checkEasterEgg(String raw) {
    final normalized = raw.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized != 'kendrick lamar') return;
    if (_easterEggTriggered) return;
    
    _easterEggTriggered = true;
    _searchController.clear();

    // Включаем трек
    context.read<PlayerProvider>().playTrack(MockData.theyNotLikeUs);
    
    // Сбрасываем флаг, чтобы можно было вызвать снова
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _easterEggTriggered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();
    final tracks = provider.allTracks;
    if (_shuffledGenres.isEmpty && provider.allTracks.isNotEmpty) {
      _shuffledGenres = _getAllGenres(provider)..shuffle();
    }
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

    final filteredTracks = tracks.where((track) {
      if (_selectedWorld == null) return true;
      return track.world == _selectedWorld;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. AppBar (оставил логотип, как в дизайне)
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

            // 2. TopNavigationBar (поиск + кнопки)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TopNavigationBar(),
              ),
            ),

            // 3. Заголовок страницы
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BROWSE / ALL GENRES',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Every shade of\nsound.',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 42),
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

            // 4. Фильтры
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

            // 5. Сетка карточек
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
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.77,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => TrackCard(track: filteredTracks[index]),
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
          border: Border.all(color: isSelected ? AppTheme.accent : Colors.white24),
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