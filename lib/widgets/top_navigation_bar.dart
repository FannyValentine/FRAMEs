// lib/widgets/top_navigation_bar.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../models/soundtrack.dart';

class TopNavigationBar extends StatefulWidget {
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;

  const TopNavigationBar({
    super.key,
    this.searchController,
    this.onSearchChanged,
  });

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  late TextEditingController _controller;
  List<Track> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.searchController ?? TextEditingController();
    _controller.addListener(_onSearch);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearch);
    if (widget.searchController == null) _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    final provider = context.read<PlayerProvider>();
    final results = provider.allTracks.where((t) {
      return t.title.toLowerCase().contains(query) ||
          t.artist.toLowerCase().contains(query) ||
          t.albumTitle.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _searchResults = results;
      _isSearching = true;
    });

    widget.onSearchChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Поле поиска
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(PhosphorIconsRegular.magnifyingGlass, color: AppTheme.textSecondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Search scores, composers, worlds...',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_isSearching)
                IconButton(
                  icon: const Icon(PhosphorIconsRegular.x, color: AppTheme.textSecondary, size: 18),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _searchResults = [];
                      _isSearching = false;
                    });
                  },
                ),
              const Text('⌘ K', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
        ),

        // Выпадающие результаты поиска
        if (_isSearching && _searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final track = _searchResults[index];
                return ListTile(
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: track.imageUrl.isNotEmpty
                          ? Image.network(track.imageUrl, fit: BoxFit.cover)
                          : Container(color: Colors.grey[800]),
                    ),
                  ),
                  title: Text(track.title, style: const TextStyle(color: AppTheme.textPrimary)),
                  subtitle: Text(track.artist, style: const TextStyle(color: AppTheme.textSecondary)),
                  onTap: () {
                    context.read<PlayerProvider>().playTrack(track);
                    _controller.clear();
                    setState(() {
                      _searchResults = [];
                      _isSearching = false;
                    });
                  },
                );
              },
            ),
          ),

        const SizedBox(height: 24),

        //  Кнопки: Wrap без фиксированной ширины
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildButton(context, 'Discover', PhosphorIconsRegular.compass, 0),
            _buildButton(context, 'Browse', PhosphorIconsRegular.squaresFour, 1),
            _buildButton(context, 'The listening room', PhosphorIconsRegular.waveform, 2, isActiveDot: true),
            _buildButton(context, 'Film', PhosphorIconsRegular.filmStrip, 3),
            _buildButton(context, 'Anime', PhosphorIconsRegular.sparkle, 4),
            _buildButton(context, 'Animation', PhosphorIconsRegular.smiley, 5),
            _buildButton(context, 'Saved soundtracks', PhosphorIconsRegular.waveform, 6),
            _buildButton(context, 'Favorites', PhosphorIconsRegular.heart, 7),
            _buildButton(context, 'Recently played', PhosphorIconsRegular.clockCounterClockwise, 8),
            _buildButton(context, 'Create a playlist', PhosphorIconsRegular.plus, 9),
            _buildButton(context, 'My playlists', PhosphorIconsRegular.queue, 10),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, int index, {bool isActiveDot = false}) {
    final nav = context.watch<NavigationProvider>();
    final isActive = nav.currentIndex == index;

    return GestureDetector(
      onTap: () => context.read<NavigationProvider>().setIndex(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accent.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, //   ширина по содержимому
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.accent : AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.accent : AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isActive && isActiveDot) ...[
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppTheme.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}