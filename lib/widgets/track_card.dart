// lib/widgets/track_card.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../models/soundtrack.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import 'cover_image.dart';

class TrackCard extends StatelessWidget {
  final Track track;

  const TrackCard({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();
    final isFav = provider.isFavorite(track.id);
    final isSaved = provider.isSaved(track.id);

    return GestureDetector(
      onTap: () => context.read<PlayerProvider>().playTrack(track),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                CoverImage(
                  url: track.imageUrl,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(8),
                ),
                // 👇 Избранное (сердечко) — слева сверху
                Positioned(
                  top: 8,
                  left: 8,
                  child: _buildIconButton(
                    icon: isFav ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
                    color: isFav ? AppTheme.accent : Colors.white,
                    onTap: () => context.read<PlayerProvider>().toggleFavorite(track.id),
                  ),
                ),
                // 👇 Сохранить (закладка) — справа сверху
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildIconButton(
                    icon: isSaved ? PhosphorIconsFill.bookmarkSimple : PhosphorIconsRegular.bookmarkSimple,
                    color: isSaved ? AppTheme.accent : Colors.white,
                    onTap: () => context.read<PlayerProvider>().toggleSaved(track.id),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(track.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(track.artist,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
          child: Icon(icon, key: ValueKey(icon), color: color, size: 18),
        ),
      ),
    );
  }
}