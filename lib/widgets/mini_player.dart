// lib/widgets/mini_player.dart
// ignore_for_file: dead_code
import '../widgets/cover_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../screens/player_screen.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final track = playerProvider.currentTrack;

    // Если трека нет — не показываем плеер
    if (track == null) {
      return const SizedBox.shrink();
    }

    // Реальная позиция и длительность из плеера
    final position = playerProvider.position;
    final duration = playerProvider.duration;
    final progress = duration.inMilliseconds > 0
        ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlayerScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Color(0xFF141414),
          border: Border(
            top: BorderSide(color: Colors.white10, width: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Обложка трека — обёрнута в ClipRRect
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CoverImage(
                          url: track.imageUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 12),

                // Информация о треке
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'NOW PLAYING / ${track.albumTitle.toUpperCase()}',
                        style: const TextStyle(
                          color: AppTheme.accent,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        track.title,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        track.artist,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Кнопка Play/Pause
                IconButton(
                  onPressed: () => context.read<PlayerProvider>().togglePlayPause(),
                  icon: Icon(
                    playerProvider.isPlaying
                        ? PhosphorIconsRegular.pauseCircle
                        : PhosphorIconsRegular.playCircle,
                    color: AppTheme.accent,
                    size: 40,
                  ),
                ),
                IconButton(
                onPressed: () => context.read<PlayerProvider>().playNext(),
                icon: const Icon(PhosphorIconsRegular.skipForward, color: AppTheme.textPrimary, size: 24),
              ),
              ],
            ),

            const SizedBox(height: 6),

            // Прогресс-бар и время
            Row(
              children: [
                // mini_player.dart
                Text(
                  _formatDuration(playerProvider.duration),
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accent),
                      minHeight: 3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(duration),
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}