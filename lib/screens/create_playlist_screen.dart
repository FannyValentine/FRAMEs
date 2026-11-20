// lib/screens/create_playlist_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../data/supabase_playlist_repository.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cover_image.dart';
import '../widgets/top_navigation_bar.dart';
import '../providers/navigation_provider.dart';

class CreatePlaylistScreen extends StatefulWidget {
  const CreatePlaylistScreen({super.key});

  @override
  State<CreatePlaylistScreen> createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _repo = SupabasePlaylistRepository();
  final Set<String> _selectedTrackIds = {};
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _createPlaylist() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название плейлиста')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final playlist = await _repo.createPlaylist(
        name: name,
        description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      );

      for (final trackId in _selectedTrackIds) {
        await _repo.addTrackToPlaylist(playlist.id, trackId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Плейлист «$name» создан')),
        );
        context.read<NavigationProvider>().setIndex(0); // назад на Discover
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allTracks = context.watch<PlayerProvider>().allTracks;

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
                'Create a playlist',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 36),
              ),
              const SizedBox(height: 8),
              const Text(
                'Give your own world a soundtrack.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Playlist name',
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 24),

              Text(
                'Start with a few favorites.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                '${_selectedTrackIds.length} tracks selected',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Список треков с чекбоксами
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allTracks.length,
                itemBuilder: (context, index) {
                  final track = allTracks[index];
                  final isSelected = _selectedTrackIds.contains(track.id);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedTrackIds.add(track.id);
                        } else {
                          _selectedTrackIds.remove(track.id);
                        }
                      });
                    },
                    title: Text(track.title, style: const TextStyle(color: AppTheme.textPrimary)),
                    subtitle: Text(track.artist, style: const TextStyle(color: AppTheme.textSecondary)),
                    secondary: SizedBox(
                      width: 40,
                      height: 40,
                      child: CoverImage(url: track.imageUrl, borderRadius: BorderRadius.circular(4)),
                    ),
                    activeColor: AppTheme.accent,
                    checkColor: Colors.black,
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _createPlaylist,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Create playlist', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}