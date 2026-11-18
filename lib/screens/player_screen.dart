// lib/screens/player_screen.dart
// ignore_for_file: dead_code

import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final track = playerProvider.currentTrack;

    if (track == null) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: Text('Ничего не играет')),
      );
    }

    final position = playerProvider.position;
    final duration = playerProvider.duration;
    final isPlaying = playerProvider.isPlaying;

    final maxMs = duration.inMilliseconds.toDouble();
    final currentMs = position.inMilliseconds.toDouble().clamp(0.0, maxMs);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowDown),
          onPressed: () => Navigator.pop(context),
        ),
        title: RichText(
          text: const TextSpan(
            text: 'FRAME ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: AppTheme.textPrimary,
            ),
            children: [
              TextSpan(text: '/', style: TextStyle(color: AppTheme.accent)),
            ],
          ),
        ),
        centerTitle: true,
        actions: const [
          Icon(PhosphorIconsRegular.dotsThree),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // 1. Верхняя подпись
            const Text(
              'NOW PLAYING',
              style: TextStyle(
                color: AppTheme.accent,
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Spirited Away · Original soundtrack',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 32),

            // 2. Название и композитор
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 28),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(track.artist, style: const TextStyle(fontSize: 16)),
                      Text(
                        '${track.albumTitle.toUpperCase()} / '
                        '${track.duration != null ? '${track.duration!.inMinutes} MIN' : '-- MIN'}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(PhosphorIconsRegular.heart, color: AppTheme.accent),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 3. Обложка — растягивается на всё свободное место
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox.expand(
                  child: Image.asset(
                          track.imageUrl,
                          fit: BoxFit.cover, // 👈 заполняет всё, обрезая края
                          errorBuilder: (_, _, _) => Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(PhosphorIconsRegular.image, size: 80, color: Colors.white54),
                            ),
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 4. Слайдер
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                activeTrackColor: AppTheme.accent,
                inactiveTrackColor: Colors.grey[800],
                thumbColor: AppTheme.accent,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                value: currentMs,
                max: maxMs > 0 ? maxMs : 1.0,
                onChanged: (value) {
                  context
                      .read<PlayerProvider>()
                      .seek(Duration(milliseconds: value.toInt()));
                },
              ),
            ),

            // 5. Динамический таймер
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 6. Кнопки управления (Play по центру)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(PhosphorIconsRegular.shuffle, color: AppTheme.textSecondary, size: 24),
                IconButton(
                  icon: const Icon(PhosphorIconsRegular.skipBack, size: 32),
                  onPressed: () {},
                ),
                GestureDetector(
                  onTap: () => context.read<PlayerProvider>().togglePlayPause(),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppTheme.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? PhosphorIconsFill.pause : PhosphorIconsFill.play,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(PhosphorIconsRegular.skipForward, size: 32),
                  onPressed: () {},
                ),
                const Icon(PhosphorIconsRegular.repeat, color: AppTheme.textSecondary, size: 24),
              ],
            ),

            const SizedBox(height: 24),

            // 7. Нижние теги
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.accent.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'HI-FI / LOSSLESS',
                    style: TextStyle(color: AppTheme.accent, fontSize: 10, letterSpacing: 1),
                  ),
                ),
                const Row(
                  children: [
                    Icon(PhosphorIconsRegular.listDashes, size: 16, color: AppTheme.textSecondary),
                    SizedBox(width: 4),
                    Text('Queue', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}