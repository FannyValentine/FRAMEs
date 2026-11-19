// lib/screens/listening_room_screen.dart
import 'package:material_ui/material_ui.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/top_navigation_bar.dart';
import '../providers/navigation_provider.dart';

class ListeningRoomScreen extends StatelessWidget {
  const ListeningRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();
    final tracks = provider.allTracks;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Верхняя навигация
              const TopNavigationBar(),
              const SizedBox(height: 32),

              // 2. Заголовок и "View all"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      'If you want something new',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 32, height: 1.1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: const [
                      Text('View all',
                          style: TextStyle(
                              color: AppTheme.accent, fontSize: 14)),
                      SizedBox(width: 4),
                      Icon(PhosphorIconsRegular.arrowUpRight,
                          color: AppTheme.accent, size: 16),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Список треков
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tracks.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.white10,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final track = tracks[index];
                  final isFirst = index == 0;

                  // Первый трек — выделенная карточка
                  if (isFirst) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.accent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Индикатор воспроизведения (анимация)
                          SizedBox(
                            width: 24,
                            child: Icon(
                              PhosphorIconsRegular.waveform,
                              color: AppTheme.accent,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track.title,
                                  style: const TextStyle(
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  track.artist,
                                  style: const TextStyle(
                                      color: AppTheme.accent, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  track.albumTitle,
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              provider.isFavorite(track.id)
                                  ? PhosphorIconsFill.heart
                                  : PhosphorIconsRegular.heart,
                              color: AppTheme.accent,
                            ),
                            onPressed: () =>
                                context.read<PlayerProvider>().toggleFavorite(track.id),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            track.formattedDuration,
                            style: const TextStyle(
                                color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }

                  // Остальные треки — обычные строки
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        // Номер трека
                        SizedBox(
                          width: 24,
                          child: Text(
                            (index + 1).toString().padLeft(2, '0'),
                            style: const TextStyle(
                                color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.title,
                                style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                track.artist,
                                style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                track.albumTitle,
                                style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            provider.isFavorite(track.id)
                                ? PhosphorIconsFill.heart
                                : PhosphorIconsRegular.heart,
                            color: provider.isFavorite(track.id)
                                ? AppTheme.accent
                                : AppTheme.textSecondary,
                            size: 20,
                          ),
                          onPressed: () =>
                              context.read<PlayerProvider>().toggleFavorite(track.id),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          track.formattedDuration,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 4. Кнопка "See all genres"
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.read<NavigationProvider>().setIndex(1); // Переход на Browse
                  },
                  child: const Text(
                    'See all genres',
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 120), // Отступ для мини-плеера
            ],
          ),
        ),
      ),
    );
  }
}