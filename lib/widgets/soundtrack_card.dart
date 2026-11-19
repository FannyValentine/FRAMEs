// lib/widgets/soundtrack_card.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../models/soundtrack.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cover_image.dart';

class SoundtrackCard extends StatelessWidget {
  final Soundtrack soundtrack;

  const SoundtrackCard({super.key, required this.soundtrack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 👇 Обработчик нажатия
      onTap: () {
        if (soundtrack.tracks.isNotEmpty) {
          context.read<PlayerProvider>().playTrack(soundtrack.tracks.first);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: soundtrack.imageUrl.isNotEmpty
                  ? CoverImage(
                      url:soundtrack.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(PhosphorIconsRegular.image, color: Colors.white54),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            soundtrack.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  soundtrack.composer,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                soundtrack.releaseYear.toString(),
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}