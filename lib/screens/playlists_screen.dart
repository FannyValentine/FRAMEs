// lib/screens/playlists_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../data/supabase_playlist_repository.dart';
import '../models/playlist.dart';
import '../theme/app_theme.dart';
import '../widgets/top_navigation_bar.dart';
import '../providers/player_provider.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  final _repo = SupabasePlaylistRepository();
  List<Playlist> _playlists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final list = await _repo.fetchUserPlaylists();
      setState(() => _playlists = list);
    } catch (e) {
      debugPrint('Ошибка загрузки плейлистов: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopNavigationBar(),
              const SizedBox(height: 32),
              Text(
                'Your playlists',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 36),
              ),
              const SizedBox(height: 24),

              if (_playlists.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'Пока нет плейлистов.\nСоздайте первый на экране «Create a playlist».',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _playlists.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.white10),
                  itemBuilder: (context, index) {
                    final playlist = _playlists[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          image: playlist.coverUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(playlist.coverUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: playlist.coverUrl == null
                            ? const Icon(Icons.music_note, color: AppTheme.textSecondary)
                            : null,
                      ),
                      title: Text(playlist.name, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                      subtitle: Text('${playlist.tracks.length} треков', style: const TextStyle(color: AppTheme.textSecondary)),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_circle_fill, color: AppTheme.accent, size: 32),
                        onPressed: () {
                          if (playlist.tracks.isNotEmpty) {
                            context.read<PlayerProvider>().playTrack(playlist.tracks.first);
                          }
                        },
                      ),
                      onTap: () {
                        context.read<PlayerProvider>().playPlaylist(playlist.tracks); 
                        // Здесь можно открыть экран с треками плейлиста
                        // Пока просто запускаем первый трек
                        if (playlist.tracks.isNotEmpty) {
                          context.read<PlayerProvider>().playTrack(playlist.tracks.first);
                        }
                      },
                    );
                  },
                ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}