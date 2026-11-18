// lib/screens/browse_screen.dart
import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';

import '../data/supabase_track_repository.dart';
import '../models/soundtrack.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/track_card.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  // Текущий выбранный мир (null = "All worlds")
  SoundtrackWorld? _selectedWorld;

  // --- Поиск ---
  final TextEditingController _searchController = TextEditingController();
  final SupabaseTrackRepository _repo = SupabaseTrackRepository();
  Timer? _debounce;

  String _query = '';
  List<Track>? _searchResults; // null = режим "без поиска"
  bool _isSearching = false;
  String? _searchError;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value);

    _debounce?.cancel();

    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _searchResults = null;
        _isSearching = false;
        _searchError = null;
      });
      return;
    }

    // Debounce 350 мс, чтобы не спамить сервер на каждый символ
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(trimmed);
    });
  }

  Future<void> _runSearch(String query) async {
    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      final results = await _repo.searchTracks(query);
      if (!mounted) return;
      // Защита от гонок: если запрос успел устареть — игнорируем
      if (_searchController.text.trim() != query) return;
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _searchError = 'Ошибка поиска: $e';
        _isSearching = false;
      });
    }
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {
      _query = '';
      _searchResults = null;
      _isSearching = false;
      _searchError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();
    final tracks = provider.allTracks;

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
              Text(provider.errorMessage!,
                  style: const TextStyle(color: Colors.red)),
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

    // Источник данных: результаты поиска с сервера ИЛИ локальный список
    final baseTracks = _searchResults ?? tracks;

    // Фильтр по миру применяется и к результатам поиска
    final filteredTracks = baseTracks.where((track) {
      if (_selectedWorld == null) return true;
      return track.world == _selectedWorld;
    }).toList();

    final isSearchMode = _query.trim().isNotEmpty;

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
                    TextSpan(
                        text: '/', style: TextStyle(color: AppTheme.accent)),
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

            // 2. Заголовок
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Поисковая строка
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) {
                    final trimmed = v.trim();
                    if (trimmed.isNotEmpty) _runSearch(trimmed);
                  },
                  style: const TextStyle(color: AppTheme.textPrimary),
                  cursorColor: AppTheme.accent,
                  decoration: InputDecoration(
                    hintText: 'Композитор, фильм или песня...',
                    hintStyle:
                        const TextStyle(color: AppTheme.textSecondary),
                    prefixIcon: const Icon(
                      PhosphorIconsRegular.magnifyingGlass,
                      color: AppTheme.textSecondary,
                    ),
                    suffixIcon: _isSearching
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.accent,
                              ),
                            ),
                          )
                        : _query.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(PhosphorIconsRegular.x,
                                    color: AppTheme.textSecondary),
                                onPressed: _clearSearch,
                              ),
                    filled: true,
                    fillColor: AppTheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
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

            // 5. Ошибка поиска
            if (_searchError != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _searchError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            // 6. Сетка
            SliverPadding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
              sliver: filteredTracks.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            isSearchMode && !_isSearching
                                ? 'Ничего не найдено по «$_query».\nПопробуй иначе.'
                                : 'Nothing here yet.\nTry a different filter.',
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(color: AppTheme.textSecondary),
                          ),
                        ),
                      ),
                    )
                  : SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.65,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            TrackCard(track: filteredTracks[index]),
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
          color:
              isSelected ? AppTheme.accent.withOpacity(0.2) : Colors.transparent,
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